             PGM

             DLTF       FILE(QTEMP/AB#WLAO)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(AB#WLAO) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/AB#WLAO2)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(AB#WLAO2) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(AB#WLAO)  TOFILE(QTEMP/AB#WLAO )
             OVRDBF     FILE(AB#WLAO2) TOFILE(QTEMP/AB#WLAO2)

             CALL       PGM(AB#RAO1)

             ENDPGM
