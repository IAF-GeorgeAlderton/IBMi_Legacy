             PGM
             /*** ABAC74 ***************************************/
             /*       内示変動数チェック範囲設定             */
             /*         MSK.KUNIEDA         1998.02.17         */
             /*************************************** ABAC74 ***/
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&HENDOU) TYPE(*CHAR) LEN(6)
             DCLF       FILE(ABAPW74)
             RTVDTAARA  DTAARA(ABAC74DAT) RTNVAR(&HENDOU)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

             CHGVAR     VAR(&@SHND) VALUE(%SST(&HENDOU 1 3))
             CHGVAR     VAR(&@EHND) VALUE(%SST(&HENDOU 4 3))

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(ABAPW741)
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&IN20) VALUE('0')
             CHGVAR     VAR(&IN21) VALUE('0')
                 CHGVAR VAR(&MSG)    +
                        VALUE('                                  ')
             IF (&IN01  *EQ '1' ) GOTO END
             /*   入力値チェック */

             IF  (&@SHND  *EQ 000)  DO
                 CHGVAR VAR(&IN20) VALUE('1')
                 CHGVAR VAR(&IN99) VALUE('1')
                 CHGVAR VAR(&MSG) VALUE('開始値を入力して下さい')
                 GOTO STP1
             ENDDO
             IF  (&@EHND  *EQ 000)  DO
                 CHGVAR VAR(&IN21) VALUE('1')
                 CHGVAR VAR(&IN99) VALUE('1')
                 CHGVAR VAR(&MSG) VALUE('終了値を入力して下さい')
                 GOTO STP1
             ENDDO
             IF  (&@SHND  *GE &@EHND)  DO
                 CHGVAR VAR(&IN21) VALUE('1')
                 CHGVAR VAR(&IN20) VALUE('1')
                 CHGVAR VAR(&IN99) VALUE('1')
                 CHGVAR VAR(&MSG)    +
                        VALUE('開始値と終了値が正しくありません。')
                 GOTO STP1
             ENDDO
             IF  (&IN05 *EQ '1') DO
                 CHGVAR  VAR(%SST(&HENDOU 1 3)) VALUE(&@SHND)
                 CHGVAR  VAR(%SST(&HENDOU 4 3)) VALUE(&@EHND)
                 CHGDTAARA  DTAARA(ABAC74DAT) VALUE(&HENDOU)
             ENDDO
             ELSE DO
                 GOTO STP1
             ENDDO
END:         ENDPGM
