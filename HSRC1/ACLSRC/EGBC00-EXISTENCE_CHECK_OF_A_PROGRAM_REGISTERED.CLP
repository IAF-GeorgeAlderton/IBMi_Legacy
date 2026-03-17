             PGM    PARM(&PGMN &ERRC)
             /** EGBC00 ************************************/
             /* EXISTENCE CHECK  OF A PROGRAM REGISTERED WITH  MENU */
             /*         MAMORU OKUDA 1987.04.28        */
             /**********************************************/
             DCL        VAR(&PGMN) TYPE(*CHAR) LEN(6)
             DCL        VAR(&ERRC) TYPE(*CHAR) LEN(1)
             CHKOBJ     OBJ(&PGMN) OBJTYPE(*PGM)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STEP01))
             GOTO       STEP02
 STEP01:     CHGVAR     VAR(&ERRC) VALUE('E')
             GOTO       END
 STEP02:     CHGVAR     VAR(&ERRC) VALUE(' ')
 END:        ENDPGM
