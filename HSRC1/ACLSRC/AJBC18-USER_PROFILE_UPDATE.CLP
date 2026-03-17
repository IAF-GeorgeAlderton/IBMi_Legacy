             PGM
             /*** AJBC18 **********************************/
             /* USER PROFILE UPDATE                       */
             /*        H.ITO          87.05.20            */
             /********************************** AJBC18 ***/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             IF         (&USER *NE 'QSECOFR') DO
 STP1:       SNDPGMMSG  MSG('( G ) PASSWORD IS QSECOFR. USE IT TO +
                          SIGN-ON.') TOMSGQ(&WSID) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ 'g')) +
                          THEN(SIGNOFF)
             GOTO       STP1
             ENDDO

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 80) +
                          LPI(6) OVRFLW(60) RPLUNPRT(*YES ' ') +
                          OUTQ(QPRINTA) FORMTYPE(K6H1) HOLD(*YES)
             CALL       PGM(AJBR18) PARM(&USER)
             DLTOVR     FILE(*ALL)

             ENDPGM
