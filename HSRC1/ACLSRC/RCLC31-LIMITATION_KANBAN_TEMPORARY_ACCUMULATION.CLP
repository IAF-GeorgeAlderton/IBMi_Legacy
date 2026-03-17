             PGM
             /**RCLC31***************************************/
             /* ...LIMITATION KANBAN TEMPORARY ACCUMULATION DATA CHANGE   */
             /*         I-HASADA           84.07.21         */
             /***************************************RCLC31**/
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PK) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHKOBJ     OBJ(RCLACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(CTP1))

 CTP2:       SNDPGMMSG  MSG('(G) LIMITED K TEMP ACCUMULATION DATA IS +
                          ACTIVE WAIT MINUTES') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +
                          THEN(GOTO CMDLBL(CTP2))
             GOTO       SEND

 CTP1:       CRTDTAARA  DTAARA(HFILE1/RCLACT) TYPE(*CHAR) LEN(10) +
                          TEXT('FOR LIMITED K TEMPORARY +
                          ACCUMULATION DATA CHECK')

             CLRPFM     FILE(RCLWP32)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(RCLR32) PARM(&PK)
             CLRPFM     FILE(RCLWP32)

             IF         (&PK *EQ '5') GOTO STP1
             GOTO       END

 STP1:       OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(RCLR31)
             DLTOVR     FILE(QPRINT)

 END:        DLTDTAARA  DTAARA(RCLACT)

 SEND:       ENDPGM
