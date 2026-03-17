             PGM

             CRTDUPOBJ  OBJ(ABBWP76) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/ABBWP76
             CRTDUPOBJ  OBJ(ABBWL76) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ABBWP77) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/ABBWP77
             CRTDUPOBJ  OBJ(ABBWL77) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ABBWP78) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/ABBWP78


             OVRDBF     FILE(ABBWP76) TOFILE(QTEMP/ABBWP76)
             OVRDBF     FILE(ABBWL76) TOFILE(QTEMP/ABBWL76)
             OVRDBF     FILE(ABBWP77) TOFILE(QTEMP/ABBWP77)
             OVRDBF     FILE(ABBWL77) TOFILE(QTEMP/ABBWL77)
             OVRDBF     FILE(ABBWP78) TOFILE(QTEMP/ABBWP78)

             CALL       PGM(ABBR76)
             DLTOVR *ALL

             ENDPGM
