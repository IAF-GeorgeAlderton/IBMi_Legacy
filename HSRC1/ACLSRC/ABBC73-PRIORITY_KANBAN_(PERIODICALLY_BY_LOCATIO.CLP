             PGM

             CRTDUPOBJ  OBJ(ABBWP74) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/ABBWP74
             CRTDUPOBJ  OBJ(ABBWP72) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/ABBWP72
             CRTDUPOBJ  OBJ(ABBWP73) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/ABBWP73

      /*     OVRPRTF    FILE(QPRINT) PAGESIZE(*N 198) CPI(15) +
                          COPIES(12)  */

             OVRDBF     FILE(ABBWP74) TOFILE(QTEMP/ABBWP74)
             OVRDBF     FILE(ABBWP72) TOFILE(QTEMP/ABBWP72)
             OVRDBF     FILE(ABBWP73) TOFILE(QTEMP/ABBWP73)
             CALL       PGM(ABBR73)
             DLTOVR *ALL

             ENDPGM
