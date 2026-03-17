             PGM        PARM(&PER &PMBR &PLIB)
             /** AJBC74 ******************************************/
             /*  ..AS/400 IAF ATC<-->AOYAMA DATABASE TRANSFER..  */
             /*  ..SRCMBR.SRCFILE.LIBRARY                        */
             /*      I-HASADA                    2001.04.23      */
             /****************************************** AJBC74 **/
             DCL        VAR(&PER) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PMBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&PER) VALUE('*')

             CHKOBJ     OBJ(&PLIB/&PMBR) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801 CPF3275 CPF9810) EXEC(GOTO +
                          CMDLBL(END))
             CHGVAR     VAR(&PER) VALUE(' ')

 END:        ENDPGM
