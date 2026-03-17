             PGM
             /**** GDGC07 *****************************************/
             /*  PRINT OF ORDER SHEET / TOTALIZATION OF PART NO.  */
             /*                                                   */
             /*   ASJ                                             */
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
             DCL        VAR(&FLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&REC)    TYPE(*DEC)  LEN(10 0)

             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
             OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
             OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)


             /* TEST MODE CHECK */
             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO
/*JW1        /* *************** */


             RTVDTAARA  DTAARA(HWFILE1/GDGC07DT (1 6)) RTNVAR(&DDATEX)
/*JW1        IF         COND(&DDATE *EQ &DDATEX) THEN(DO)              */
/*JW1          SNDBRKMSG  MSG('YOU CAN USE IT ONLY ONCE A DAY  +       */
/*JW1                     TRY NEXT DAY         .') TOMSGQ(&WSID) +     */
/*JW1                     MSGTYPE(*INFO)                               */
/*JW1          GOTO       @END                                         */
/*JW1        ENDDO                                                     */
/*JW1                                                                  */
/*JW1                                                                  */
/*JW1   /*ＡＳＪデータ件数チェック*/
/*JW1        CALL       PGM(GDGR04) PARM('ASJ' &D@KN)                 */

 @STRT:
             SNDRCVF    DEV(&WSID) RCDFMT(DSP01)

/*JW1        IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@END))   */
/*JW1        IF         COND(&IN05 *NE '1') THEN(GOTO CMDLBL(@STRT))  */
/*JW1                                                                 */
             CHGDTAARA  DTAARA(HWFILE1/GDGC07DT) VALUE(&DDATE)
/*JW1                                                                 */
/*JW1                                                                 */
/*JW1        CHKOBJ     OBJ(&WLIB/GDGWP9Z) OBJTYPE(*FILE)             */
/*JW1        MONMSG     MSGID(CPF9801) EXEC(DO)                       */
/*JW1        CRTPF      FILE(&WLIB/GDGWP9Z) RCDLEN(128) +             */
/*JW1                     OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +       */
/*JW1                     LVLCHK(*NO) AUT(*ALL)                       */
/*JW1        ENDDO                                                    */
/*JW1                                                                 */
/*JW1        CPYF       FROMFILE(GDGWP9X) TOFILE(GDGWP9Z) +           */
/*JW1                     MBROPT(*REPLACE) FMTOPT(*NOCHK)             */
/*JW1        MONMSG     MSGID(CPF0000)                                */
/*JW1        CLRPFM     FILE(&WLIB/GDGWP9X)                           */
/*JW1                                                                 */
/*JW1                                                                 */
             OVRDBF     FILE(GDGWP9X) TOFILE(&WLIB/GDGWP9Z)
/*JW1                                                                */
/*JW1   /*                                             */
/*JW1   /*データ抜出処理                             */
/*JW1   /*                 GDGPP05   -->   GDGPP01,02  */
/*JW1                                                                 */
             OVRPRTF    FILE(QPRINT) OUTQ(LANPRT03) FORMTYPE(K6H1) +
                          HOLD(*NO)
/*JW1        CALL       PGM(GDGRB6) PARM('ASJ')                       */
/*JW1                                                                 */
/*JW1   /*抜出データ有無チェック*/
/*JW1        RTVMBRD    FILE(GDGPP01) NBRCURRCD(&REC)                 */
/*JW1        IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(@END))      */
/*JW1                                                                 */
/*JW1        CPYF       FROMFILE(GDGPP01)  TOFILE(HFILE1/GDGPP01@SV) +*/
/*JW1                     MBROPT(*REPLACE) CRTFILE(*YES)              */
/*JW1                                                                 */
/*JW1   /*                                             */
/*JW1     サマリー処理                                             */
/*JW1                      GDGPP01   -->   GDGPP10                   */
/*JW1                                                                */
/*JW1        CALL       PGM(GDGRB5) PARM(&PPUSER &PPGO 'ASJ')        */
/*JW1        IF         (&PPGO *NE 'GO')   GOTO @END                 */
/*JW1                                                                */
/*JW1   /*                                                */
/*JW1   /*抜出データの削除（サマリー済）                */
/*JW1   /*                 GDGPP01 -> GDGPP01X -> GDGPP01 */
/*JW1                                                                */
/*JW1        CPYF       FROMFILE(GDGPP01)  TOFILE(QTEMP/GDGPP01X) +  */
/*JW1                     MBROPT(*REPLACE) CRTFILE(*YES) +           */
/*JW1                     INCREL((*IF IASYHZ *EQ 0))                 */
/*JW1        MONMSG     MSGID(CPF0000)                               */

             CLRPFM     FILE(GDGPP01)
             CPYF       FROMFILE(QTEMP/GDGPP01X) TOFILE(GDGPP01) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)


             CPYF       FROMFILE(GDGPP10) TOFILE(TFILE1/GDGPP10@SV) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             CPYF       FROMFILE(BTAPP05) TOFILE(TFILE1/BTAPP05@SV) +
                          MBROPT(*REPLACE) CRTFILE(*YES)

             CLRPFM     FILE(GDGWP07)

             OVRPRTF    FILE(QPRINT2) OUTQ(LANPRT03) FORMTYPE(K6H1) +
                        SAVE(*YES) HOLD(*NO)

             CALL       PGM(GDGRB7) PARM(&DDATEX 'ASJ')

             DLTOVR QPRINT2

         /* NOT SCANNED */
             CALL       PGM(GDGRC7) PARM('ASJ')


          /* NOT SCANNED AT SHIPPING */
             CALL       PGM(GDGRC8) PARM('ASJ')


             DLTOVR QPRINT


             CHKOBJ     OBJ(&FLIB/TRANS) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(&FLIB/TRANS) TYPE(*CHAR) LEN(2) +
                          TEXT('IAF->ASJ TRANSFER CHECK'))
             CHGDTAARA  DTAARA(&FLIB/TRANS (1 1)) VALUE('*')

             CLRPFM     FILE(AANPP50) /*ＳＣＡＮ重複チェック用 */

 @END:       ENDPGM

