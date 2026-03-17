             PGM

             CRTDUPOBJ  OBJ(AB#WP9I) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(AB#WP9I) TOFILE(QTEMP/AB#WP9I)

             CLRPFM     AB#WP9I

             CALL       PGM(AB#R9I)

             DLTOVR     FILE(*ALL)

             ENDPGM
