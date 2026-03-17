             PGM

             CRTDUPOBJ  OBJ(ALFWP20) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(ALFWP20) TOFILE(QTEMP/ALFWP20)

             CALL       PGM(ALFR20)

             DLTOVR     FILE(*ALL)

             ENDPGM
