             PGM        PARM(&FIL &LIB &PGM)
             /** SAVC05 **********************************************/
             /*  SAVE IMPORT DATA TO IMPWP02                         */
             /*  JW    2023.04.26                                    */
             /* ---------------------------------                    */
             /* EX.                                                  */
             /* &FIL = 'PMO'                                         */
             /* &LIB = 'HFILE1'                                      */
             /* &PGM = 'ABACP6'                                      */
             /********************************************************/
             DCL        VAR(&FIL ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM ) TYPE(*CHAR) LEN(10)

             CHKOBJ     OBJ(&LIB/&FIL ) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(ENDP))

             OVRDBF     FILE(IMPORT) TOFILE(&LIB/&FIL)

             CALL       PGM(SAVR05) PARM(&FIL &LIB &PGM)

ENDP:        ENDPGM
