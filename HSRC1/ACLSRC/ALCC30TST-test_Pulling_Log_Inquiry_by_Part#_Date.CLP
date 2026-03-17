             PGM

             CRTDUPOBJ  OBJ(ALCWP30) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(ALCWP30) TOFILE(QTEMP/ALCWP30)

             OVRDBF     FILE(ALCPW30) TOFILE(TOBJ1/ALCPW30)

             CALL       PGM(TOBJ1/ALCR30)

             DLTOVR     FILE(*ALL)

             ENDPGM
