             PGM
             /** AB#C9B *********************************/
             /*  CUSTOMER SHIPPING STATUS INQ BY PART   */
             /*  JW       2022.01.24                    */
             /*******************************************/
             DCL        VAR(&NONY)  TYPE(*CHAR) LEN(4)

             CHGVAR     VAR(&NONY) VALUE('    ')

             DLTF       FILE(QTEMP/AB#WP9B)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#WP9B) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/AB#WP9B)

             OVRDBF     FILE(AB#WP9B) TOFILE(QTEMP/AB#WP9B)
             CALL       PGM(AB#R9B) PARM(&NONY)

             ENDPGM
