             PGM
             /** BBAC01 ****************************************/
             /* TOYOTA SYSTEM VOLUME PRODUCTION UNIT PRICE M/F UPDATE */
             /*         KOHHY             90.04.12             */
             /**************************************** BBAC01 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)   TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGJOB     SWS(00000000)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1)
             CALL       PGM(BBAR01) PARM(&USER)
             DLTOVR     FILE(*ALL)

             IF         (%SWITCH(1XXXXXXX)) DO
 STP1:       SNDPGMMSG  MSG('( G ) TOYOTA SYSTEM VOLUME PRODUCTION +
                          UNIT PRICE M/F UPDATE +
                          THERE IS ERROR LIST. REFER.'+
                          ) TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         (&KOTE *NE 'G') GOTO STP1
             ENDDO

             ENDPGM
