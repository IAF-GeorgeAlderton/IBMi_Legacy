             PGM

             CRTDUPOBJ  OBJ(ALCWP22) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(ALCWP22) TOFILE(QTEMP/ALCWP22)

             CALL       PGM(ALCR22)

             DLTOVR     FILE(*ALL)

             ENDPGM
