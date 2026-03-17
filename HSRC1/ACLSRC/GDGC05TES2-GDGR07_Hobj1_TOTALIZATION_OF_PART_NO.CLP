             PGM
             /**** GDGC05 *****************************************/
             /*  PRINT OF ORDER SHEET / TOTALIZATION OF PART NO.  */
             /*                                                   */
             /*  ADD TEST MODE  2004.1.22   HAYA            */
             /*  REMOVE DUPULICATE SCAN  12/06/2004         */
             /*  TCH56 TCH 05/05/05 CHANGED SORTING FOR GDGR15    */
             /*  TCH57 TCH 05/23/05 ADDED ONCE A DAY REST.        */
             /*  TCHK1 TCH 05/07/07 CHG UPDATE DATARA TIMING      */
             /*  TCHK2 TCH 05/06/09 ADD PREVIOUS ORDER DATE       */
             /*  TCHK3 TCH 12/02/09 ADD GDGR07(BARASHI)           */
             /*  TCHK4 TCH 02/04/10 CHG GDGR07 PARM DATE          */
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
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DDATEX) TYPE(*CHAR) LEN(6)
/* TCHK2 */  DCL        VAR(&PRVDATE) TYPE(*CHAR) LEN(6)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

/* TEMP6 */  OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
/* TEMP6 */  OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
/* TEMP6 */  OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             /* TEST MODE CHECK */
             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO
             /* *************** */

             CPYF       FROMFILE(TFILE1/GDGPP05) TOFILE(QTEMP/GDGP) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF IASYHZ *EQ 0))
             RTVMBRD    FILE(QTEMP/GDGP) NBRCURRCD(&REC)
             CHGVAR     VAR(&D@KN) VALUE(&REC)
    /*  TCH57 */
             RTVDTAARA  DTAARA(HWFILE1/GDGC05DT (1 6)) RTNVAR(&DDATEX)
/* TEST      IF         COND(&DDATE *EQ &DDATEX) THEN(DO)          */
/* TEST        SNDBRKMSG  MSG('YOU CAN USE IT ONLY ONCE A DAY  +   */
/* TEST                   TRY NEXT DAY         .') TOMSGQ(&WSID) + */
/* TEST                   MSGTYPE(*INFO)                           */
/* TEST        GOTO       @END                                     */
/* TEST      ENDDO                                                 */
/* TCHK1     ELSE DO                                             */
/* TCHK1       CHGDTAARA  DTAARA(HWFILE1/GDGC05DT) VALUE(&DDATE) */
/* TCHK1     ENDDO                                               */
    /*  TCH57 */
  @STRT:
             SNDRCVF    DEV(&WSID) RCDFMT(DSP01)

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@END))
             IF         COND(&IN05 *NE '1') THEN(GOTO CMDLBL(@STRT))

/* TEST      CHGDTAARA  DTAARA(HWFILE1/GDGC05DT) VALUE(&DDATE) */

        /*  MSK 2004.11.10 */
             CHKOBJ     OBJ(TWFILE1/GDGWP9Z) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)

             CRTPF      FILE(TWFILE1/GDGWP9Z) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO) AUT(*ALL)
             ENDDO

             CPYF       FROMFILE(TWFILE1/GDGWP9X) +
                          TOFILE(TWFILE1/GDGWP9Z) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(TWFILE1/GDGWP9X)

             OVRDBF     FILE(GDGWP9X) TOFILE(TWFILE1/GDGWP9Z)

             OVRPRTF    FILE(QPRINT) OUTQ(QDKT) FORMTYPE(K6H1)

             IF         COND(&REC *GT 0) THEN(DO)
             OVRDBF     FILE(GDGPL06) TOFILE(TFILE1/GDGPL06)
             OVRDBF     FILE(GDKPL02) TOFILE(HFILE1/GDKPL02)
             OVRDBF     FILE(GDGPP01) TOFILE(TFILE1/GDGPP01)
             OVRDBF     FILE(GDGPP02) TOFILE(TFILE1/GDGPP02)
             OVRDBF     FILE(GDGWP9X) TOFILE(TWFILE1/GDGWP9X)
             CALL       PGM(HOBJ1/GDGR06)
             ENDDO

             OVRDBF     FILE(GDGPL01) TOFILE(TFILE1/GDGPL01)
             OVRDBF     FILE(GDGPL10) TOFILE(TFILE1/GDGPL10)
             OVRDBF     FILE(BTAPP05) TOFILE(TFILE1/BTAPP05)
             OVRDBF     FILE(BTAPP41) TOFILE(TFILE1/BTAPP41)
             OVRDBF     FILE(AAPPL05) TOFILE(HFILE1/AAPPL05)
             OVRDBF     FILE(AKBPL06) TOFILE(HFILE1/AKBPL06)
             OVRDBF     FILE(AANPL05) TOFILE(HFILE1/AANPL05)
             OVRDBF     FILE(FCEPL01) TOFILE(HFILE1/FCEPL01)
             OVRDBF     FILE(AKCPL01) TOFILE(HFILE1/AKCPL01)
             OVRDBF     FILE(AAPTL01) TOFILE(HFILE1/AAPTL01)
             OVRDBF     FILE(AKBPL04) TOFILE(HFILE1/AKBPL04)
             OVRDBF     FILE(AANPL06) TOFILE(HFILE1/AANPL06)
             OVRDBF     FILE(GDGPL19) TOFILE(TFILE1/GDGPL19)
             OVRDBF     FILE(AB#PL18) TOFILE(HFILE1/AB#PL18)
             OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/AGDPL12)
             OVRDBF     FILE(GDGWP9X) TOFILE(TWFILE1/GDGWP9X)
             CALL       PGM(HOBJ1/GDGR05) PARM(&PPUSER &PPGO)
             IF         (&PPGO *NE 'GO')   GOTO @END

             CPYF       FROMFILE(TFILE1/GDGPP01) +
                          TOFILE(QTEMP/GDGPP01X) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF IASYHZ *EQ 0))
             MONMSG     MSGID(CPF0000)

         /*  CPYF       FROMFILE(GDGPP01)  TOFILE(YASU/GDGPP01_BK) +
                          MBROPT(*ADD) CRTFILE(*YES)   */
         /*  MONMSG     MSGID(CPF0000)                 */

             CLRPFM     FILE(TFILE1/GDGPP01)
             CPYF       FROMFILE(QTEMP/GDGPP01X) +
                          TOFILE(TFILE1/GDGPP01) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)

/* TCHK3 START */
             CPYF       FROMFILE(TFILE1/GDGPP10) +
                          TOFILE(TFILE1/GDGPP10@SV) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
/* TEST      CPYF       FROMFILE(TFILE1/BTAPP05) +
                          TOFILE(TFILE1/BTAPP05@SV) +
                          MBROPT(*REPLACE) CRTFILE(*YES) */
             CLRPFM     FILE(TWFILE1/GDGWP07)

             OVRPRTF    FILE(QPRINT2) OUTQ(QDKT) FORMTYPE(K6H1)

/* TCHK4     RTVDTAARA  DTAARA(GDGC12DATE) RTNVAR(&PRVDATE) */

/* TCHK4     CALL       PGM(GDGR07) PARM(&PRVDATE) */
             OVRDBF     FILE(GDGPL10) TOFILE(TFILE1/GDGPL10)
             OVRDBF     FILE(AANPL06) TOFILE(HFILE1/AANPL06)
             OVRDBF     FILE(AAPTL01) TOFILE(HFILE1/AAPTL01)
             OVRDBF     FILE(AKBPL04) TOFILE(HFILE1/AKBPL04)
             OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/AGDPL12)
             OVRDBF     FILE(FCEPL01) TOFILE(HFILE1/FCEPL01)
             OVRDBF     FILE(FCEPL11) TOFILE(HFILE1/FCEPL11)
             OVRDBF     FILE(BTAPL05) TOFILE(TFILE1/BTAPL05)
             OVRDBF     FILE(GDGWP07) TOFILE(TWFILE1/GDGWP07)
/* TCHK4 */  CALL       PGM(HOBJ1/GDGR07) PARM(&DDATEX)
/* TCHK3 END   */

             /* PRINT OF KANBAN TOTAL LIST */
   /* TCH56  OVRPRTF    FILE(QPRINT) OUTQ(QPRINT) FORMTYPE(K6H1)  */
             OVRPRTF    FILE(QPRINT2) OUTQ(QDKT) FORMTYPE(K6H1)
             CLRPFM     FILE(TWFILE1/GDGWP15)
             MONMSG     MSGID(CPF0000)
/* TCHK2 START */
/* TCHK2     CALL GDGR15 */
/* TCHK3     RTVDTAARA  DTAARA(GDGC12DATE) RTNVAR(&PRVDATE) */
/* TCHK4 */  RTVDTAARA  DTAARA(GDGC12DATE) RTNVAR(&PRVDATE)
             OVRDBF     FILE(GDGPL10) TOFILE(TFILE1/GDGPL10)
             OVRDBF     FILE(GDGPL19) TOFILE(TFILE1/GDGPL19)
             OVRDBF     FILE(BTAPL05) TOFILE(TFILE1/BTAPL05)
             OVRDBF     FILE(AZAPP51) TOFILE(HFILE1/AZAPP51)
             OVRDBF     FILE(AANPL06) TOFILE(HFILE1/AANPL06)
             OVRDBF     FILE(AAPTL01) TOFILE(HFILE1/AAPTL01)
             OVRDBF     FILE(AKBPL04) TOFILE(HFILE1/AKBPL04)
             OVRDBF     FILE(AB#PL18) TOFILE(HFILE1/AB#PL18)
             OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/AGDPL12)
             OVRDBF     FILE(MCENP13) TOFILE(HFILE1/MCENP13)
             OVRDBF     FILE(FCEPL41) TOFILE(HFILE1/FCEPL41)
             OVRDBF     FILE(FCEPL01) TOFILE(HFILE1/FCEPL01)
             OVRDBF     FILE(FCEPL11) TOFILE(HFILE1/FCEPL11)
             OVRDBF     FILE(GDGWP15) TOFILE(TWFILE1/GDGWP15)
             CALL PGM(HOBJ1/GDGR15) PARM(&PRVDATE)
/* TCHK2 END */
 /* NOT SCANNED */
 /* TEST     CALL GDGR17 */
 /* NOT SCANNED AT SHIPPING */
 /* TEST     CALL GDGR18    */
 /* DUPLICAT SCANNING       */
       /*    CALL AB#RAK  */

             DLTOVR QPRINT
             DLTOVR QPRINT2

 /* TEST     CHKOBJ     OBJ(&FLIB/TRANS) OBJTYPE(*DTAARA)          */
 /* TEST     MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +            */
 /* TEST                  DTAARA(&FLIB/TRANS) TYPE(*CHAR) LEN(2) + */
 /* TEST                  TEXT('IAF->ASJ TRANSFER CHECK'))         */
 /* TEST     CHGDTAARA  DTAARA(&FLIB/TRANS (1 1)) VALUE('*')       */
 /* TEST                                                           */
 /* TEST     CLRPFM     FILE(AANPP50)                              */

 @END:       ENDPGM
