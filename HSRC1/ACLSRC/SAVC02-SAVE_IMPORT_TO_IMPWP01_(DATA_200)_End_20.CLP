             PGM        PARM(&FILE &LIB &PGM)
             /** SAVC02 ****************************/
             /*  SAVE IMPORT DATA TO IMPWP01       */
             /*  J.WATANABE  2021.03.11            */
             /**************************************/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM)  TYPE(*CHAR) LEN(10)

             CHKOBJ     OBJ(&LIB/&FILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(ENDP))

             OVRDBF     FILE(IMPORT) TOFILE(&LIB/&FILE)

             CALL       PGM(SAVR02) PARM(&FILE &LIB &PGM)

ENDP:        ENDPGM
