             PGM
             /** AAJC11 ************************************/
             /* TCH 04/20/05 FACIL ACUM. MAINT PROGRAM         */
             /**********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)   TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSNO) USER(&USER)

             CHKOBJ     OBJ(HWFILE1/FACILDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP1))

 STP2:       SNDPGMMSG  MSG('( G ) FACIL ACCUMULATE QTY. FILE +
                          MAINTENANCE PROGRAM IS ACTIVE..  WAIT FOR +
                           A WHILE                                    -
                       ') TOMSGQ(&WSNO) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         COND((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) +
                          THEN(GOTO CMDLBL(STP2))
             GOTO       END

 STP1:       CRTDTAARA  DTAARA(HWFILE1/FACILDA) TYPE(*CHAR) LEN(10) +
                          TEXT('FACIL MAINTENANCE                 +
                          ') AUT(*ALL)

             CALL       PGM(AB#R93)

             DLTDTAARA  DTAARA(HWFILE1/FACILDA)

 END:        ENDPGM
