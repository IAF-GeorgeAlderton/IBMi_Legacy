             PGM
/** ALDC9I ************************************************/
/*  SHIPPING OVERFLOW INQ                                 */
/*  LEC          2023.06.02                               */
/**********************************************************/

             DLTF       FILE(QTEMP/ALDWP9I)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(ALDWP9I) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(ALDWP9I) TOFILE(QTEMP/ALDWP9I)

             CALL       PGM(ALDR9I)

             DLTOVR     FILE(*ALL)

             ENDPGM
