             PGM
             /**FCLCP6*******************************************/
             /* ZLOCATION ORGANIZE LIST CREATE */
             /*            N.SHIBAYAMA 1984.07.17               */
             /*******************************************FCLCP6**/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7) VALUE(QPRINT )
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             GOTO STEP4

 STEP1:      SNDPGMMSG  MSG('( G.C ) ZLOCATION M/F ORGANIZE ! +
                          FCLPP21｡ 2 ｢SET BACKUP TAPE') +
                          TOMSGQ(QSYSOPR) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(STEP2))
             IF         COND((&KOTAE = 'C') *OR (&KOTAE = 'c')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       CMDLBL(STEP1)

 STEP2:      INZTAP     DEV(TAPE1) CHECK(*NO)
             SAVOBJ     OBJ(FCLPP21) LIB(HFILE) DEV(TAPE1) +
                          OBJTYPE(*FILE) VOL(AOYAMA)

 STEP3:      SNDPGMMSG  MSG('( G.C ) TAKE OUT FCLPP21 BUCKUP +
                          TAPE,AND RETURN IT TO AN ORIGINAL +
                          POSITION') TOMSGQ(QSYSOPR) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(STEP4))
             IF         COND((&KOTAE = 'C') *OR (&KOTAE = 'c')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       CMDLBL(STEP3)

 STEP4:      RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) RPLUNPRT(*YES) OUTQ(&PRT) +
                          FORMTYPE(K6H1) COPIES(1) IGCDTA(&PIGCD)
             CALL       PGM(FCLR61) PARM(&USER)
             DLTOVR     FILE(QPRINT)

END:         ENDPGM
