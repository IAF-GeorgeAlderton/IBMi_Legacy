             PGM        PARM(&PMSG &PKINP &PMSGQ &PKOUT)
             /** AB800C ****************************************/
             /*プログラム・メッセージ外部ルーチン　ＣＬ版    */
             /*  CODING:T.SAKASHITA                2008.12.05  */
             /**************************************** VNTC10 **/
             DCL        VAR(&PMSG) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PMSGQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)

             DCL        VAR(&PKINP1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PKINP2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PKINP3) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PKINP4) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PKINP5) TYPE(*CHAR) LEN(1)

             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)

             CHGVAR     VAR(&PKINP1) VALUE(%SST(&PKINP 1 1))
             CHGVAR     VAR(&PKINP2) VALUE(%SST(&PKINP 2 1))
             CHGVAR     VAR(&PKINP3) VALUE(%SST(&PKINP 3 1))
             CHGVAR     VAR(&PKINP4) VALUE(%SST(&PKINP 4 1))
             CHGVAR     VAR(&PKINP5) VALUE(%SST(&PKINP 5 1))
 RTN:
             SNDPGMMSG  MSG(&PMSG) TOMSGQ(&PMSGQ) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&PKOUT)

             IF         COND(&PKOUT *EQ ' ') THEN(GOTO CMDLBL(RTN))

             IF         COND(&PKOUT *NE &PKINP1 *AND &PKOUT *NE +
                          &PKINP2 *AND &PKOUT *NE &PKINP3 *AND +
                          &PKOUT *NE &PKINP4 *AND &PKOUT *NE +
                          &PKINP5) THEN(DO)
             GOTO       CMDLBL(RTN)
             ENDDO

             ENDPGM
