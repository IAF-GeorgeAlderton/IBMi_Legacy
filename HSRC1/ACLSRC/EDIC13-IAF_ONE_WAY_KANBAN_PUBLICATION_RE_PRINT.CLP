             PGM
             /** EDIC13 ************************************/
             /* IAF ONE WAY KANBAN PUBLICATION RE-PRINT    */
             /*  C:N.HAYAKAWA      1997.09.23              */
             /**********************************************/
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID)   USER(&US)
             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     SWS(00000000)

 STP1:       CHKOBJ     OBJ(EDIC10ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP3))

 STP2:       SNDPGMMSG  MSG('( G ) ONE WAY KANBAN DATA CREATE.WAIT +
                          FOR A WHILE') TOMSGQ(&WSID) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         COND((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) +
                          THEN(GOTO CMDLBL(STP2))
             GOTO       EXT

 STP3:       CRTDTAARA  DTAARA(EDIC10ACT) TYPE(*CHAR) LEN(10) +
                          TEXT('ONE WAY KANBAN DATA CREATE +
                          CHECK<TV>') AUT(*ALL)
             MONMSG     MSGID(CPF1023) EXEC(GOTO CMDLBL(STP1))

             DLTF       FILE(HWFILE1/EDIWP11)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/EDIWP11) RCDLEN(256) AUT(*ALL)

             OVRDBF     FILE(INPUT) TOFILE(HWFILE1/EDIWP11BK)

             CALL       PGM(EDIR13)

 SEND:       DLTDTAARA  DTAARA(EDIC10ACT)
             MONMSG     MSGID(CPF2105)

 EXT:        ENDPGM
