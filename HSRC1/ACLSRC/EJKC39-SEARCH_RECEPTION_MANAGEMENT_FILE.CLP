             PGM        PARM(&FILE &LIB &MOJI &RTN)
             /** EJKC39 ********************************/
             /* SEARCH RECEPTION MANAGEMENT FILE       */
             /*    **ORIGINAL IS JK592C FROM ASJ**     */
             /*   T.SAKAKI     2016.12.13              */
             /******************************** EJKC38 **/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&MOJI) TYPE(*CHAR) LEN(20) /* WORD */
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&RTN)  VALUE(' ')

             CHKOBJ     OBJ(&LIB/&FILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@END))

             OVRDBF     FILE(INPUT) TOFILE(&LIB/&FILE)
             CALL       PGM(EJKR39) PARM(&MOJI &RTN)
             DLTOVR     FILE(INPUT)


 @END:
             ENDPGM
