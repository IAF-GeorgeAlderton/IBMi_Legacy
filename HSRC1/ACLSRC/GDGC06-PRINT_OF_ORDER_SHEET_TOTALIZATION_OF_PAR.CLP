             PGM
             /**** GDGC06 *****************************************/
             /*  PRINT OF ORDER SHEET / TOTALIZATION OF PART NO.  */
             /*                                                   */
             /*   ATC                                             */
             /*                                                   */
             /*****************************************************/
             DCLF       FILE(GDGPW06)

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
             /* *************** */


             RTVDTAARA  DTAARA(HWFILE1/GDGC06DT (1 6)) RTNVAR(&DDATEX)
             IF         COND(&DDATE *EQ &DDATEX) THEN(DO)
               SNDBRKMSG  MSG('YOU CAN USE IT ONLY ONCE A DAY  +
                          TRY NEXT DAY         .') TOMSGQ(&WSID) +
                          MSGTYPE(*INFO)
               GOTO       @END
             ENDDO


        /*ＡＴＣデータ件数チェック*/
             CALL       PGM(GDGR04) PARM('ATC' &D@KN)

 @STRT:
             SNDRCVF    DEV(&WSID) RCDFMT(DSP01)

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@END))
             IF         COND(&IN05 *NE '1') THEN(GOTO CMDLBL(@STRT))

             CHGDTAARA  DTAARA(HWFILE1/GDGC06DT) VALUE(&DDATE)


             OVRDBF     FILE(GDGWP9X) TOFILE(&WLIB/GDGWP9Z)

        /*                                             */
        /*データ抜出処理                             */
        /*                 GDGPP05   -->   GDGPP01,02  */

             OVRPRTF    FILE(QPRINT) OUTQ(LANPRT03) FORMTYPE(K6H1) +
                          HOLD(*NO)
             CALL       PGM(GDGRB6) PARM('ATC')

        /*抜出データ有無チェック*/
             RTVMBRD    FILE(GDGPP01) NBRCURRCD(&REC)

        /*０件でも実行できるように2015.01.06 T.SAKASITA */
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(@JUMP))

             CPYF       FROMFILE(GDGPP01)  TOFILE(HFILE1/GDGPP01@SA) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
@JUMP:
        /*                                             */
        /*サマリー処理                               */
        /*                 GDGPP01   -->   GDGPP10     */

             CALL       PGM(GDGRB5) PARM(&PPUSER &PPGO 'ATC')
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


             CPYF       FROMFILE(GDGPP10) TOFILE(TFILE1/GDGPP10@SA) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             CPYF       FROMFILE(BTAPP05) TOFILE(TFILE1/BTAPP05@SA) +
                          MBROPT(*REPLACE) CRTFILE(*YES)

             CLRPFM     FILE(GDGWP07)

             OVRPRTF    FILE(QPRINT2) OUTQ(LANPRT03) FORMTYPE(K6H1) +
                        SAVE(*YES) HOLD(*NO)

             CALL       PGM(GDGRB7) PARM(&DDATEX 'ATC')

             DLTOVR QPRINT2

         /* NOT SCANNED */
             CALL       PGM(GDGRC7) PARM('ATC')


          /* NOT SCANNED AT SHIPPING */
             CALL       PGM(GDGRC8) PARM('ATC')


             DLTOVR QPRINT


             CHKOBJ     OBJ(&FLIB/TRANSA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(&FLIB/TRANSA) TYPE(*CHAR) LEN(2) +
                          TEXT('IAF->ATC TRANSFER CHECK'))
             CHGDTAARA  DTAARA(&FLIB/TRANSA (1 1)) VALUE('*')

    /*       CLRPFM     FILE(AANPP50)ＳＣＡＮ重複チェック用 */

 @END:       ENDPGM

