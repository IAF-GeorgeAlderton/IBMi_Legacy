             PGM
/** ALCC60 ************************************************/
/*  STORE IN LOCATION INQ                                 */
/*  J.WATANABE   2019.03.26                               */
/**********************************************************/

             DLTF       FILE(QTEMP/ALCWP60)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(ALCWP60) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(ALCWP60) TOFILE(QTEMP/ALCWP60)

             CALL       PGM(ALCR60)

             DLTOVR     FILE(*ALL)

             ENDPGM
