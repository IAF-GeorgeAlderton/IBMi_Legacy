             PGM

             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(10) +
                          VALUE('HFILE1    ')

 /*  **************************************************    */
 /*  clear file/field definitions file                     */
             CLRPFM     FILE(FFDPP01)

 /*  **************************************************    */
 /*  build file/field definitions file                     */
             CALL       PGM(UTLC75) PARM(&LIBR)

 /*  **************************************************    */
 /*  send file/field definitions to SQL03                  */

             ADDLIBLE   LIB(RDB50)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(RDBR55) PARM(&LIBR)

             RMVLIBLE   LIB(RDB50)
             MONMSG     MSGID(CPF0000)
 /*  **************************************************    */

             ENDPGM
