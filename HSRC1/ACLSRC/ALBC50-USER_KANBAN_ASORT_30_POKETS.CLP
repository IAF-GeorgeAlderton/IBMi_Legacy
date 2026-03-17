             PGM
             /** ALBC50 ************************************/
             /* USER KANBAN ASORT  30 POKETS     */
             /*  N.HAYAKAWA                    1997.06.27  */
             /*************************** COPY FROM ALBC20 **/
             DCL        VAR(&REC) TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&BIN) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ABADS1) TYPE(*CHAR) LEN(48)
             DCL        VAR(&SW1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SDAY) TYPE(*CHAR) LEN(8)


             RTVJOBA    JOB(&WSID)
             RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)
             CHGVAR     VAR(&PM) VALUE(%SST(&ABADS1 5 2))
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)


 STP1:       CHKOBJ     OBJ(ALBC40ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP2))

 STP3:       SNDPGMMSG  MSG('( G ) +
                          ALBC40 NOW CALLING OTHER WORK STATION.+
                           WAIT FOR A WHILE') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         COND((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) +
                          THEN(GOTO CMDLBL(STP3))
             GOTO       END

 STP2:       CRTDTAARA  DTAARA(ALBC40ACT) TYPE(*CHAR) LEN(10) +
                          TEXT('USER KANBAN ASORTDE') AUT(*ALL)
             CLRPFM     FILE(HWFILE1/ALBWP43)
             CLRPFM     FILE(HFILE1/ALBPP40)

             CALL       PGM(ALBR50) PARM(&PM &BIN &SW1 &US &SDAY)

             IF         (&SW1 *EQ '*') GOTO SEND

             CLRPFM     FILE(HWFILE1/ALBWP46)
             CALL       PGM(ALBR54) PARM(&BIN)

             CLRPFM     FILE(HWFILE1/ALBWP45)
             CALL       PGM(ALBR55) PARM(&BIN)

             CALL       PGM(ALBR56) PARM(&BIN &US &SDAY)

 SEND:       DLTDTAARA  DTAARA(ALBC40ACT)

 END:        ENDPGM
