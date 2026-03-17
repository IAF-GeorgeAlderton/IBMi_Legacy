             PGM
             /** AJFC01 ****************************************/
             /*   IAF RPG III / CL SOURCE PROGRAM INPUT        */
             /* I-HASADA                        96.07.10       */
             /**************************************** AJFC01 **/
             DCL        VAR(&PLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PSRC) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PPGM) TYPE(*CHAR) LEN(6)

             DCL        VAR(&P@LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P@SRC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P@PGM) TYPE(*CHAR) LEN(10)

             DCL        VAR(&PTYP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PTX) TYPE(*CHAR) LEN(50)
             DCL        VAR(&WPGM) TYPE(*CHAR) LEN(7)

             DCL        VAR(&MSG) TYPE(*CHAR) LEN(256)

             RTVJOBA    JOB(&WS) USER(&USER)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYP &PRTG)

             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(AJFR01) PARM(&PLIB &PSRC &PPGM &PTYP &USER)

             IF         (%SWITCH(0XXXXXXX)) DO
             GOTO       END
             ENDDO

             CHGVAR     VAR(&P@LIB) VALUE(&PLIB)
             CHGVAR     VAR(&P@SRC) VALUE(&PSRC)
             CHGVAR     VAR(&P@PGM) VALUE(&PPGM)
             CALL       PGM(VVVRY1) PARM(&P@LIB &P@SRC &P@PGM)

             CHGJOB     OUTQ(&PRT)
             STRSEU     SRCFILE(&PLIB/&PSRC) SRCMBR(&PPGM) +
                          TYPE(&PTYP) OPTION(5)
             MONMSG     MSGID(EDT9007) EXEC(DO)
             CHGVAR     VAR(&MSG) VALUE('Error found on STRSEU +
                          command.')
             CALL       PGM(APLR9C) PARM('AJFC01' &MSG)
             GOTO       CMDLBL(END)
             ENDDO

             CHGJOB     OUTQ(QPRINT)











 END:        ENDPGM
