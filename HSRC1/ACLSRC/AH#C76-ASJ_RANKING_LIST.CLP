             PGM
             /** AH#C76 **********************************/
             /* ASJ RANKING LIST                         */
             /*                                          */
             /*                                          */
             /*                                          */
             /********************************************/

             CRTDUPOBJ  OBJ(AH#WP76) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(AH#WP77) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM QTEMP/AH#WP76
             CLRPFM QTEMP/AH#WP77

             OVRDBF     FILE(AH#WP76) TOFILE(QTEMP/AH#WP76)
             OVRDBF     FILE(AH#WP77) TOFILE(QTEMP/AH#WP77)

             CALL       PGM(AH#R76)

             DLTOVR     FILE(*ALL)

             ENDPGM
