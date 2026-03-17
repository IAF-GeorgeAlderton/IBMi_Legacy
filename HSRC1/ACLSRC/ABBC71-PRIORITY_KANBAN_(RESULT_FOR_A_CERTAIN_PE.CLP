             PGM

             CRTDUPOBJ  OBJ(ABBWP70) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/ABBWP70

       /*    OVRPRTF    FILE(QPRINT) PAGESIZE(*N 198) CPI(15) */

             OVRDBF     FILE(ABBWP70) TOFILE(QTEMP/ABBWP70)
             CALL       PGM(ABBR71)
             DLTOVR *ALL

             ENDPGM
