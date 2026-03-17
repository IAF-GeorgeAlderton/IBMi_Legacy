             PGM
             /**********************************************/
             /* TEN-DAY REPORT FORM & DETAILS DISPLAY BY   */
             /* INTRAL COMPANY PART NO                     */
             /*         MAR.17,'87.        GBC             */
             /**********************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&US) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7) VALUE(' ')
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&YMD) TYPE(*CHAR) LEN(80) VALUE(' ')
             DCL        VAR(&DD) TYPE(*CHAR) LEN(20) VALUE(' ')
             DCL        VAR(&YOB) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&LIST) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&LAST) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&OP) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(256) VALUE(' ')
             DCL        VAR(&RTNCD) TYPE(*CHAR) LEN(1) VALUE(' ')
             RTVJOBA    JOB(&WSID) USER(&US)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 STEP6:      CHGJOB     OUTQ(&PRTG)
             IF         COND(&TYPE ¬= 'K') THEN(CHGVAR VAR(&PRT) +
                          VALUE(&PRTG))
             CHGVAR     VAR(&RTNCD) VALUE('0')

             CHKOBJ     OBJ(EACWP42) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR VAR(&RTNCD) +
                          VALUE('1'))
             IF (&RTNCD = '0')    THEN(DLTF  EACWP42)
             CRTPF      FILE(QTEMP/EACWP42) SRCFILE(HSRC1/ADDSSRC) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          LVLCHK(*NO)

             OVRDBF     FILE(EACWP42) TOFILE(QTEMP/EACWP42) SHARE(*YES)
             OVRPRTF    FILE(QPRINT) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          SHARE(*YES)
             OVRPRTF    FILE(JYUNPO) TOFILE(QPRINT) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) SHARE(*YES)

 STEP1:      RMVMSG     CLEAR(*ALL)
             CHGJOB     SWS(00000000)
             CALL       PGM(EACR41) PARM(&YMD &DD &YOB)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@ERR))
             IF         COND(%SWITCH(X1XXXXXX)) THEN(GOTO CMDLBL(END))

 STEP2:      CHGJOB     SWS(00000000)
             CALL       PGM(EACR42) PARM(&YMD &LIST)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@ERR))
             IF         COND(%SWITCH(1XXXXXXX)) THEN(GOTO CMDLBL(END))
             IF         COND(%SWITCH(X1XXXXXX)) THEN(GOTO +
                          CMDLBL(STEP1))

             CHGJOB     SWS(00000000)
             CALL       PGM(EACR43) PARM(&YMD &US &YOB)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@ERR))

             IF         (&LIST *EQ 'N') GOTO STEP3
             CHGVAR     VAR(&OP) VALUE('1')

             CALL       PGM(EACR44) PARM(&YMD &LAST &US &YOB)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@ERR))

 STEP3:      IF         COND(%SWITCH(XXXX1XXX)) THEN(DO)
             CLRPFM     FILE(QTEMP/EACWP42)
             GOTO       CMDLBL(STEP2)
             ENDDO

             IF         COND((&OP ¬= '1') & %SWITCH(XXXXX1XX)) +
                          THEN(GOTO CMDLBL(STEP4))
             CHGVAR     VAR(&LAST) VALUE('1')
             CALL       PGM(EACR44) PARM(&YMD &LAST &US &YOB)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@ERR))

 STEP4:      DLTOVR     FILE(*ALL)
             GOTO       END

 @ERR:       RCVMSG     RMV(*NO) MSG(&ERR)
             SNDPGMMSG  MSG(&ERR) MSGTYPE(*DIAG)

 END:        CHGVAR     VAR(&RTNCD) VALUE('0')
             CHGJOB     OUTQ(&PRT)
             CHKOBJ     OBJ(EACWP42) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CHGVAR VAR(&RTNCD) +
                          VALUE('1'))
             IF         COND(&RTNCD = '0') THEN(DLTF +
                          FILE(EACWP42))

             ENDPGM
