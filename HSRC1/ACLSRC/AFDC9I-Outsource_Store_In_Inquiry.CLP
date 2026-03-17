             PGM
/** AFDC9I ************************************************/
/*  OUTSOURCE STORE IN INQ                                */
/*  LEC          2023.10.24                               */
/**********************************************************/

             DLTF       FILE(QTEMP/AFDWP9I)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(AFDWP9I) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(AFDWP9I) TOFILE(QTEMP/AFDWP9I)

             CALL       PGM(AFDR9I)

             DLTOVR     FILE(*ALL)

             ENDPGM
