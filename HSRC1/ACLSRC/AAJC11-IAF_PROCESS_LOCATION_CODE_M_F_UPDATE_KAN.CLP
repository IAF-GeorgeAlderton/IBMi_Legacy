             PGM
             /** AAJC11 ************************************/
             /* INTRA-PROCESS LOCATION CODE M/F UPDATE <KANJI> */
             /* C:N.HAYAKAWA                      86.09.16 */
             /**********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)   TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSNO) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

             GOTO       XXXP1

             CHKOBJ     OBJ(AAVACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP1))

 STP2:       SNDPGMMSG  MSG('( G ) KANBAN M/F LIST HANDLING OR +
                          PROD ORDER  BOOK MAKING OR PART +
                          INFORMATION M/F UPDATE HANDLING IS +
                          ACTIVE, WAIT FOR A WHILE') TOMSGQ(&WSNO) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         COND((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) +
                          THEN(GOTO CMDLBL(STP2))
             GOTO       END

 STP1:       CRTDTAARA  DTAARA(AAVACT) TYPE(*CHAR) LEN(10) +
                          TEXT('INTRA-PROCESS LOCATION M/F UPDATE +
                          HANDLING') AUT(*ALL)

 XXXP1:      CHGJOB     OUTQ(&PRTG)
             CALL       PGM(AAJR11) PARM(&WSNO)

             DLTDTAARA  DTAARA(AAVACT)

 END:        ENDPGM
