             PGM
/** ALCC9I ************************************************/
/*  CONVEYANCE OVERFLOW INQ                               */
/*  LEC          2023.07.31                               */
/**********************************************************/

             DLTF       FILE(QTEMP/ALCWP9I)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(ALCWP9I) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(ALCWP9I) TOFILE(QTEMP/ALCWP9I)

             CALL       PGM(ALCR9I)

             DLTOVR     FILE(*ALL)

             ENDPGM
