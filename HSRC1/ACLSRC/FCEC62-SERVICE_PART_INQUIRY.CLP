             PGM
/** FCEC62 ************************************************/
/*  SERVICE PARTS MASTER INQUIRY                          */
/*                                                        */
/* TCHK1 06/02/09 CREATE                                  */
/**********************************************************/

             CRTDUPOBJ  OBJ(FCEWP62) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(FCEWP62) TOFILE(QTEMP/FCEWP62)

             CALL       PGM(FCER62)

             DLTOVR     FILE(*ALL)

             ENDPGM
