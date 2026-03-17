/** ABAC50 ************************************************/
/* FORECAST ABBPP01 UPDATE FOR IAF PART#                  */
/*                                                        */
/* JW    09/25/2016 WRITTEN                               */
/**********************************************************/
             PGM

             OVRDBF     FILE(ABBPL01) TOFILE(HFILE1/ABBPL01)
             OVRDBF     FILE(ABBPL51) TOFILE(HFILE1/ABBPL51)

             CALL       PGM(HOBJ1/ABAR50)

             ENDPGM
