             PGM        PARM(&PFILE &PMBRN)
             /** AJFC40 ****************************************/
             /*  ..ＲＣＶＮＥＴＦ受信時のファイル番号選択..  */
             /*       I-HASADA                  94.12.16       */
             /* 重複起動防止                                 */
             /*       Y.MAEDA                 2010.11.17       */
             /**************************************** AJFC40 **/
             DCL        VAR(&PFILE) TYPE(*CHAR) LEN(9)
             DCL        VAR(&PMBRN) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)

 STP2:
             DLYJOB     DLY(2)
             CHKOBJ     OBJ(HFILE1/AJFC40ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP1))
             IF         COND(&COUNT *GE 30) THEN(DO)
             SNDPGMMSG  MSG('( G )RECEIVEING NETWORK FILE IS +
                          FAILED. PLEASE CONTACT ITG.') +
                          TOMSGQ(QSYSOPR) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND(&KOTAE *EQ 'G') THEN(DO)
             CHGVAR     VAR(&COUNT) VALUE(0)
             GOTO       CMDLBL(STP2)
             ENDDO
             ENDDO
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
             GOTO       CMDLBL(STP2)

 STP1:       CRTDTAARA  DTAARA(HFILE1/AJFC40ACT) TYPE(*CHAR) +
                          LEN(10) TEXT('AJFC40 IS OPERATING') AUT(*ALL)

             DLTF       FILE(HWFILE1/AJFWP40)
             MONMSG     MSGID(CPF3261 CPF2105)

             WRKNETF    USER(QFILE) OUTPUT(*OUTFILE) +
                          OUTFILE(HWFILE1/AJFWP40)

             OVRDBF     FILE(AJFWP40) TOFILE(HWFILE1/AJFWP40)
             CALL       PGM(AJFR40) PARM(&PFILE &PMBRN)
             DLTF       FILE(HWFILE1/AJFWP40)
             DLTOVR     FILE(*ALL)

 END:        DLTDTAARA  DTAARA(HFILE1/AJFC40ACT)
             MONMSG     MSGID(CPF0000)

             ENDPGM
