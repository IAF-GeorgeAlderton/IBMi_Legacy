             PGM
             /** AJFC03 ****************************************/
             /* INPUT IAF DATA DESCRIPTION(DDS) SOURCE DATA.   */
             /* I-HASADA                        96.07.10       */
             /**************************************** AJFC03 **/
             DCL        VAR(&PLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PSRC) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PFIL) TYPE(*CHAR) LEN(7)

             DCL        VAR(&P@LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P@SRC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P@FIL) TYPE(*CHAR) LEN(10)

             DCL        VAR(&PTYP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PTXT) TYPE(*CHAR) LEN(50)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PTX) TYPE(*CHAR) LEN(50)

             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)

             RTVJOBA    JOB(&WS) USER(&USER)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYP &PRTG)

             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(AJFR03) PARM(&PLIB &PSRC &PFIL &PTYP +
                          &PTXT &USER)

             IF         (%SWITCH(0XXXXXXX)) DO
             GOTO       END
             ENDDO

             CHGVAR     VAR(&P@LIB) VALUE(&PLIB)
             CHGVAR     VAR(&P@SRC) VALUE(&PSRC)
             CHGVAR     VAR(&P@FIL) VALUE(&PFIL)


             CHGJOB     OUTQ(&PRT)

             CALL       PGM(AJFR90) PARM(&P@LIB &P@SRC &P@FIL 'R')

             STRSEU     SRCFILE(&PLIB/&PSRC) SRCMBR(&PFIL) +
                          TYPE(&PTYP) TEXT(&PTXT)

             RCVMSG     MSGTYPE(*LAST) MSGID(&MSGID)

     /*ソースを変更したら変更履歴を取る*/

             IF         COND(&MSGID *EQ 'EDT0229') THEN(DO)
             CALL       PGM(AJFR90) PARM(&P@LIB &P@SRC &P@FIL 'E')
             ENDDO

             CHGJOB     OUTQ(QPRINT)

             ALCOBJ     OBJ((&PLIB/&PSRC *FILE *SHRUPD &PFIL))
             MONMSG     MSGID(CPF0948 CPF1085) EXEC(GOTO CMDLBL(END))

             OVRDBF     FILE(SRCFILE) TOFILE(&PLIB/&PSRC) MBR(&PFIL)
             CALL       PGM(AJFR06) PARM(&PTYP &PTX)
             DLTOVR     FILE(SRCFILE)

             DLCOBJ     OBJ((&PLIB/&PSRC *FILE *SHRUPD &PFIL))
             CHGPFM     FILE(&PLIB/&PSRC) MBR(&PFIL) TEXT(&PTX)

             CALL       PGM(AJFR04) PARM(&PFIL &PTX)

 END:        ENDPGM
