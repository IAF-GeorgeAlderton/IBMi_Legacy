             PGM
             /** GIGC98 ***************************/
             /*  TRANSMISSING OF INVOICS DATA     */
             /*       <ＩＡＦ-->ＡＳＪ>       */
             /*             K.YASUDA   1997.10.08 */
             /*************************** GIGC98 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             RTVJOBA    JOB(&WSID)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

 STP1:       SNDPGMMSG  MSG('( G +
                          )ＩＡＦ側でインボイスデータの復元が出来ま+
                          せんでした。情報開発Ｔ＆海外物流Ｔに連絡+
                          。 ') TOMSGQ(&WSID) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)

             IF         (&KOTAE *NE 'G') GOTO STP1
             ENDPGM
