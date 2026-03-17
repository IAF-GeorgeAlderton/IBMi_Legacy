             PGM
             /** IZAC65S ***************************************/
             /*  PRINT WIRE LOT ID TAGS                        */
             /*    LEC                      2025.10.06         */
             /**************************************************/

             ADDLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(IZAR65S)

             RMVLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF0000)

             ENDPGM
