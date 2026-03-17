             PGM
             /** ALBC45 ************************************/
             /* KANBAN DATA UPDATE                         */
             /*       CREATE DATE : NOV/06/1997.           */
             /*       AUTHOR      : K.OKACHI.              */
             /**********************************************/
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ABADS1) TYPE(*CHAR) LEN(48)
             DCL        VAR(&PM) TYPE(*CHAR) LEN(2)
             RTVJOBA    JOB(&WSID)   USER(&US)
             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)
             RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)
             CHGVAR     VAR(&PM) VALUE(%SST(&ABADS1 5 2))

 STEP1:      CHKOBJ     OBJ(ALBC40ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STEP2))

 ERR1:       SNDPGMMSG  MSG('( G ) +
                          ALBC40 NOW CALLING OTHER WORK STATION.+
                           WAIT FOR A WHILE') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         COND((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) +
                          THEN(GOTO CMDLBL(ERR1))
             GOTO       END

 STEP2:      CRTDTAARA  DTAARA(ALBC40ACT) TYPE(*CHAR) LEN(10) +
                          TEXT('USER KANBAN ASORTDE') AUT(*ALL)

             CALL ALBR60 PARM(&US &PM)

 SEND:       DLTDTAARA  DTAARA(ALBC40ACT)

 END:        ENDPGM
