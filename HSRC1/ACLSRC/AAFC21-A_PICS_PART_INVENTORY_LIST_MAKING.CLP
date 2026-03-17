             PGM
             /********************************************/
             /* A-PICS PART INVENTORY LIST MAKING      */
             /*          MAR.23,'87. GBC                 */
             /********************************************/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7) VALUE(' ')
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&SW) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(256)

             RMVMSG     CLEAR(*ALL)
             /*********************************************/
             /*COPY  DECISION ORDERING FILE TO WORK */
             /*********************************************/
             CHKOBJ     OBJ(ADANP11) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTPF      FILE(HFILE1/ADANP11) SRCFILE(HSRC1/ADDSSRC) +
                          AUT(*ALL)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@ERR))
             ENDDO

             CPYF       FROMFILE(AGAPP31) TOFILE(ADANP11) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@ERR))

             RMVMSG     CLEAR(*ALL)

             CHKOBJ     OBJ(ADANL11) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTLF      FILE(HFILE1/ADANL11) SRCFILE(HSRC1/ADDSSRC) +
                          AUT(*ALL)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@ERR))
             ENDDO

             RMVMSG     CLEAR(*ALL)

             CLRPFM     FILE(ADANP12)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@ERR))

             RMVMSG     CLEAR(*ALL)
             /*********************************************/
             /* A-PICS FLOW PART QUANTITY AND SETTING NUMBER COLLATION */
             /*********************************************/
             CALL       PGM(AAFR21) PARM(&SW)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@ERR))
             IF         COND(&SW ¬= ' ') THEN(DO)
             RTVJOBA    JOB(&JOB) USER(&USER)
/*           CALL       PGM(KZZR00) PARM(&JOB &PRT &TYPE &PRTG)      */
             CALL       PGM(AGAR00) PARM(&JOB &PRT &TYPE &PRTG)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@ERR))
             /*********************************************/
             /* PRINT A-PICSPART INVENTORY COUNTING LIST  */
             /*********************************************/
             IF         COND(&TYPE = 'K') THEN(OVRPRTF FILE(AAFPR22) +
                          DEVTYPE(*AFPDS) OUTQ(LANPRT02))
             ELSE       CMD(OVRPRTF FILE(AAFPR22) DEVTYPE(*AFPDS) +
                          OUTQ(LANPRT02))
             CALL       PGM(AAFR22)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@ERR))
             DLTOVR     FILE(AAFPR22)
             ENDDO

             CLRPFM     FILE(ADANP11)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@ERR))

             CLRPFM     FILE(ADANP12)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(@ERR))

             RETURN
 @ERR:       RCVMSG     RMV(*NO) MSG(&MSG)
             SNDPGMMSG  MSG(&MSG) MSGTYPE(*DIAG)
             RETURN
             ENDPGM
