             PGM
             /**** GDGC05 *****************************************/
             /*  PRINT OF ORDER SHEET / TOTALIZATION OF PART NO.  */
             /*                                                   */
             /*  ADD TEST MODE  2004.1.22   HAYA            */
             /*  CHANGE OUTQ    2004.6.18   H AMANO         */
             /*****************************************************/
             DCLF       FILE(GDGPW05)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPGO) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID) USER(&PPUSER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             /* TEST MODE CHECK */
             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO
             /* *************** */

             CPYF       FROMFILE(GDGPP05) TOFILE(QTEMP/GDGP) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF IASYHZ *EQ 0))
             RTVMBRD    FILE(QTEMP/GDGP) NBRCURRCD(&REC)
             CHGVAR     VAR(&D@KN) VALUE(&REC)
  @STRT:
             SNDRCVF    DEV(&WSID) RCDFMT(DSP01)

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@END))
             IF         COND(&IN05 *NE '1') THEN(GOTO CMDLBL(@STRT))

             IF         COND(&REC *GT 0) THEN(DO)
             CALL       PGM(GDGR06)
             ENDDO

             OVRPRTF    FILE(QPRINT) OUTQ(QPRINT) FORMTYPE(K6H1)
             CALL       PGM(GDGR05) PARM(&PPUSER &PPGO)
             IF         (&PPGO *NE 'GO')   GOTO @END

             CPYF       FROMFILE(GDGPP01)  TOFILE(QTEMP/GDGPP01X) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF IASYHZ *EQ 0))
             MONMSG     MSGID(CPF0000)

         /*  CPYF       FROMFILE(GDGPP01)  TOFILE(YASU/GDGPP01_BK) +
                          MBROPT(*ADD) CRTFILE(*YES)   */
         /*  MONMSG     MSGID(CPF0000)    */

             CLRPFM     FILE(GDGPP01)
             CPYF       FROMFILE(QTEMP/GDGPP01X) TOFILE(GDGPP01) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)


             /* PRINT OF KANBAN TOTAL LIST */
             OVRPRTF    FILE(QPRINT) OUTQ(QPRINT) FORMTYPE(K6H1)
             CALL GDGR15
 /* NOT SCANNED */
             CALL GDGR17
 /* NOT SCANNED AT SHIPPING */
             CALL GDGR18
 /* DUPLICAT SCANNING       */
             CALL AB#RAK

             DLTOVR QPRINT

             CHKOBJ     OBJ(&FLIB/TRANS) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(&FLIB/TRANS) TYPE(*CHAR) LEN(2) +
                          TEXT('IAF->ASJ TRANSFER CHECK'))
             CHGDTAARA  DTAARA(&FLIB/TRANS (1 1)) VALUE('*')

             CLRPFM     FILE(AANPP50)

 @END:       ENDPGM
