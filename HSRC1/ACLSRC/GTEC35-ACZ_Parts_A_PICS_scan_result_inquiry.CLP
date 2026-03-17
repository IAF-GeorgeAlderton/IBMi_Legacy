             PGM

             CRTDUPOBJ  OBJ(GTEWP35) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(GTEWP35) TOFILE(QTEMP/GTEWP35)

             CALL       PGM(GTER35)

             DLTOVR     FILE(*ALL)

             ENDPGM
