             PGM

             CRTDUPOBJ  OBJ(ALCWP30) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(ALCWP30) TOFILE(QTEMP/ALCWP30)

             CALL       PGM(ALCR30)

             DLTOVR     FILE(*ALL)

             ENDPGM
