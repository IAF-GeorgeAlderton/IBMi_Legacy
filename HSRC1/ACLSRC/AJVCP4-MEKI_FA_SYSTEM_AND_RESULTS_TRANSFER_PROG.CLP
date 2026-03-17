             PGM
             /** AJVCP4 **********************************************/
             /*メッキＦＡシステム転送投入プログラム                */
             /* 自動チェック無し                                   */
             /*   2000.08.11    K.OKACHI                             */
             /*   2001.02.27    A.MAMIYA  終了時刻を画面より入力   */
             /********************************************** AJVCP4 **/
             DCLF       FILE(AJVPWP4)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&HIZK) TYPE(*CHAR) LEN(6)
             DCL        VAR(&HIZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&TIM) TYPE(*CHAR) LEN(6)
             RTVJOBA    JOB(&WSID)
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&HIZK)
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIM)
             CALL       PGM(DATR00) PARM(&HIZK &HIZ)

             CHGVAR     VAR(&IHIZ) VALUE(&HIZ)
             CHGVAR     VAR(&ITIM) VALUE(&TIM)


             CHKOBJ     OBJ(AJVACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP1))
             CHGVAR     VAR(&IN03) VALUE('1')
             GOTO       STP2
 STP1:       CHGVAR     VAR(&IN02) VALUE('1')
 STP2:
             SNDRCVF    DEV(&WSID) RCDFMT(AJVPWP41)
             CHGVAR     VAR(&IN10) VALUE('0')
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')
             IF         (&IN01 *EQ '1') GOTO END
             IF         (&IHIZ *EQ '        ') DO
                 CHGVAR     VAR(&IN99) VALUE('1')
                 CHGVAR     VAR(&IN10) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('終了日付が、入力されていない。')
                 GOTO       STP2
             ENDDO
             IF         (&ITIM *EQ '      ') DO
                 CHGVAR     VAR(&IN99) VALUE('1')
                 CHGVAR     VAR(&IN11) VALUE('1')
                 CHGVAR     VAR(&MSG) VALUE('時間が、入力されていない。')
                 GOTO       STP2
             ENDDO
             IF         (&IHIZ *LT &HIZ) GOTO STP3
             IF         (%SST(&IHIZ 5 2) *LT '01') GOTO STP3
             IF         (%SST(&IHIZ 5 2) *GT '12') GOTO STP3
             IF         (%SST(&IHIZ 7 2) *LT '01') GOTO STP3
             IF         (%SST(&IHIZ 7 2) *GT '31') GOTO STP3

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIM)
             IF         (&IHIZ *EQ &HIZ) DO
                 IF         (&ITIM *LT &TIM) GOTO STP4
             ENDDO
             IF         (%SST(&ITIM 1 2) *LT '00') GOTO STP4
             IF         (%SST(&ITIM 1 2) *GT '23') GOTO STP4
             IF         (%SST(&ITIM 3 2) *LT '00') GOTO STP4
             IF         (%SST(&ITIM 3 2) *GT '59') GOTO STP4
             IF         (%SST(&ITIM 5 2) *LT '00') GOTO STP4
             IF         (%SST(&ITIM 5 2) *GT '59') GOTO STP4

             IF         (&IN03 *EQ '1') GOTO STP2
             IF         (&IN05 *EQ '0') GOTO STP2
             GOTO EXEC
 STP3:
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN10) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('終了日付が正しくない')
             GOTO       STP2
 STP4:
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('時間が正しくない')
             GOTO       STP2
 EXEC:
             CRTDTAARA  DTAARA(AJVACT) TYPE(*CHAR) LEN(10) +
                          TEXT('通信実行中')

             SBMJOB     CMD(CALL PGM(AJVCJ4) PARM(&IHIZ &ITIM)) +
                           JOB(MEKI) JOBD(QBATCH) JOBQ(QBATCH) +
                           RTGDTA(*JOBD) INLLIBL(*JOBD)

 END:        ENDPGM
