             PGM

             CRTDUPOBJ  OBJ(GTEWP30) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(GTEWP30) TOFILE(QTEMP/GTEWP30)

             CALL       PGM(GTER30)

             DLTOVR     FILE(*ALL)

             ENDPGM
