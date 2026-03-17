             PGM

             CRTDUPOBJ  OBJ(ALCWP20) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(ALCWP20) TOFILE(QTEMP/ALCWP20)

             CALL       PGM(TOBJ1/ALCR20)

             DLTOVR     FILE(*ALL)

             ENDPGM
