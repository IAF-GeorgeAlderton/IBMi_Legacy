             PGM        PARM(&FILE &LIB)
             /** EJKC37 ********************************/
             /* UPDATE RECEPTION MANAGEMENT FILE       */
             /*    **ORIGINAL IS JK591C FROM ASJ**     */
             /*  T.SAKAKI            2016.11.01        */
             /************************ EJKC37 **********/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB)  TYPE(*CHAR) LEN(10)

             CHKOBJ     OBJ(&LIB/&FILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@END))

             EDTDTA     FILE(&LIB/&FILE)

 @END:
             ENDPGM
