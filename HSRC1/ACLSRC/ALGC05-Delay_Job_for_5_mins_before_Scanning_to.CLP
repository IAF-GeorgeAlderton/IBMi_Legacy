/** ALGC05 ************************************************/
/*   DELAY JOB FOR 5 MINUTES                              */
/*                                                        */
/*   LEC       2017.01.18                                 */
/**********************************************************/
             PGM

             DCLF       FILE(ALGPW05D)
             SNDRCVF    RCDFMT(FMTDLY) WAIT(*NO)
             DLYJOB     DLY(300)

             ENDPGM
