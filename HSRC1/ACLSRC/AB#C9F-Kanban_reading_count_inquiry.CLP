             PGM

             CRTDUPOBJ  OBJ(AB#WP9F) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(AB#WP9F) TOFILE(QTEMP/AB#WP9F)

             CALL       PGM(AB#R9F)

             DLTOVR     FILE(*ALL)

             ENDPGM
