             PGM
             /**** GDGC07 *****************************************/
             /*  PRINT OF ORDER SHEET / TOTALIZATION OF PART NO.  */
             /*                                                   */
             /*   ASJ                                             */
             /* T.SAKAKI 08/10/2018 ASJ WORKING DATE CHECK %0001  */
             /*                                                   */
             /*****************************************************/
             DCLF       FILE(GDGPW07)

             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DDATE)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&DDATEX) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PPGO)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC)    TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&RSLT)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PMSG)  TYPE(*CHAR) LEN(256)

             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

           /*--------------------------------------------*/
           /*    CHECK ENVIRONMENT                        */
           /*--------------------------------------------*/
             CALL       PGM(ALBC01) PARM(&PPUSER &PLIB &WLIB)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             OVRDBF     FILE(AGDPP11) TOFILE(&PLIB/A@DPP11)
             OVRDBF     FILE(AGDPL11) TOFILE(&PLIB/A@DPL11)
             OVRDBF     FILE(AGDPL12) TOFILE(&PLIB/A@DPL12)

   /** %0001 **/
             RTVDTAARA  DTAARA(&WLIB/GDGC07DT (1 6)) RTNVAR(&DDATEX)
             IF         COND(&DDATE *EQ &DDATEX) THEN(DO)
             CHGVAR     VAR(&PMSG) VALUE('Only once a day. Try next day.')
             CALL       PGM(QUILNGTX) PARM(&PMSG X'00000046' '       +
                          ' '                    ' X'00000000')
             GOTO       CMDLBL(@END)
             ENDDO

/* TCHK4 S */
             CALL       PGM(GDGR99) PARM(&RSLT)
             IF         COND(&RSLT *EQ '1') THEN(DO)
             CHGVAR     VAR(&PMSG) VALUE('TODAY is not ASJ working day. +
                          Cannot Summary.')
             CALL       PGM(QUILNGTX) PARM(&PMSG X'00000046' '       +
                          ' '                    ' X'00000000')
             GOTO @END
             ENDDO

        /*ＡＳＪデータ件数チェック*/
             CALL       PGM(GDGR04) PARM('ASJ' &D@KN)

 @STRT:
             SNDRCVF    DEV(&WSID) RCDFMT(DSP01)

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@END))
             IF         COND(&IN05 *NE '1') THEN(GOTO CMDLBL(@STRT))

             CHGDTAARA  DTAARA(&WLIB/GDGC07DT) VALUE(&DDATE)


             CHKOBJ     OBJ(&WLIB/GDGWP9Z) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTPF      FILE(&WLIB/GDGWP9Z) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO) AUT(*ALL)
             ENDDO

             CPYF       FROMFILE(GDGWP9X) TOFILE(GDGWP9Z) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(&WLIB/GDGWP9X)


             OVRDBF     FILE(GDGWP9X) TOFILE(&WLIB/GDGWP9Z)

        /*                                             */
        /*データ抜出処理                             */
        /*                 GDGPP05   -->   GDGPP01,02  */

             IF         COND(&PPUSER *NE 'TEST') THEN(DO)
             OVRPRTF    FILE(QPRINT) OUTQ(LANPRT03) FORMTYPE(K6H1) +
                          HOLD(*NO)
             ENDDO

             CALL       PGM(GDGRB6) PARM('ASJ')

        /*抜出データ有無チェック*/
             RTVMBRD    FILE(GDGPP01) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(@END))

             CPYF       FROMFILE(GDGPP01)  TOFILE(&PLIB/GDGPP01@SV) +
                          MBROPT(*REPLACE) CRTFILE(*YES)

        /*                                             */
        /*サマリー処理                               */
        /*                 GDGPP01   -->   GDGPP10     */

             CALL       PGM(GDGRB5) PARM(&PPUSER &PPGO 'ASJ')
             IF         (&PPGO *NE 'GO')   GOTO @END

        /*                                                */
        /*抜出データの削除（サマリー済）                */
        /*                 GDGPP01 -> GDGPP01X -> GDGPP01 */

             CPYF       FROMFILE(GDGPP01)  TOFILE(QTEMP/GDGPP01X) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF IASYHZ *EQ 0))
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(GDGPP01)
             CPYF       FROMFILE(QTEMP/GDGPP01X) TOFILE(GDGPP01) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)


             IF         COND(&PPUSER *NE 'TEST') THEN(DO)
             CPYF       FROMFILE(GDGPP10) TOFILE(TFILE1/GDGPP10@SV) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             CPYF       FROMFILE(BTAPP05) TOFILE(TFILE1/BTAPP05@SV) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             ENDDO

             CLRPFM     FILE(GDGWP07)

             IF         COND(&PPUSER *NE 'TEST') THEN(DO)
             OVRPRTF    FILE(QPRINT2) OUTQ(LANPRT03) FORMTYPE(K6H1) +
                        SAVE(*YES) HOLD(*NO)
             ENDDO

             CALL       PGM(GDGRB7) PARM(&DDATEX 'ASJ')

             DLTOVR QPRINT2

         /* NOT SCANNED */
             CALL       PGM(GDGRC7) PARM('ASJ')


          /* NOT SCANNED AT SHIPPING */
             CALL       PGM(GDGRC8) PARM('ASJ')


         /* ASJ PARTS/WASHERS ORDER RESULT */
             CALL       PGM(GDGRC9) PARM('ASJ')


             DLTOVR QPRINT


             CHKOBJ     OBJ(&PLIB/TRANS) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(&PLIB/TRANS) TYPE(*CHAR) LEN(2) +
                          TEXT('IAF->ASJ TRANSFER CHECK'))
             CHGDTAARA  DTAARA(&PLIB/TRANS (1 1)) VALUE('*')
             CRTDTAARA  DTAARA(HFILE1/GDGC07SM) TYPE(*CHAR) LEN(6) +
                        TEXT('サマリー済み')
             MONMSG     MSGID(CPF1023)

             CLRPFM     FILE(AANPP50) /*ＳＣＡＮ重複チェック用 */

 @END:       ENDPGM

