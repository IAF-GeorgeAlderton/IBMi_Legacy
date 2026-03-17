             PGM

             CRTDUPOBJ  OBJ(ALIWP30) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(ALIWP30) TOFILE(QTEMP/ALIWP30)

             CALL       PGM(ALIR30)

             DLTOVR     FILE(*ALL)

             ENDPGM
