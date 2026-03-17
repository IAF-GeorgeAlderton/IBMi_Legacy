/** ALGC20 ************************************************/
/*  OQ - Print PreLoad Sign                               */
/*                                                        */
/* LEC  2020/03/12 - Create                               */
/**********************************************************/
             PGM

             OVRPRTF    FILE(ALGPR20) OUTQ(SAVEOUTQ) +
                          USRDFNDTA('Pre-Load Sign')

             CALL       PGM(ALGR20)


             ENDPGM
