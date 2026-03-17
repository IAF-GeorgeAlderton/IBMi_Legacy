             PGM
             /** EDIC30 ************************************/
             /* USER CUSTOMER CODE DELLVERY CODE DOCK CODE */
             /* TO IN-HOUSE CODE CONVERSION                */
             /*       CREATE DATE : 1997.11.25             */
             /*       CODING      : K.OKACHI.              */
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

 STP1:       CHKOBJ     OBJ(HFILE1/EDIC30ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP3))

 STP2:       SNDPGMMSG  MSG('( G ) THE PROCESSING IS BEING EXECUTED +
                          WITH OTHER TV.') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         COND((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) +
                          THEN(GOTO CMDLBL(STP2))
             GOTO       EXIT

 STP3:       CRTDTAARA  DTAARA(HFILE1/EDIC30ACT) TYPE(*CHAR) LEN(10) +
                          AUT(*ALL)
             MONMSG     MSGID(CPF1023) EXEC(GOTO CMDLBL(STP1))

             CALL EDIR30 PARM(&US)

 END:        DLTDTAARA  DTAARA(HFILE1/EDIC30ACT)
             MONMSG     MSGID(CPF2105)

 EXIT:       ENDPGM
