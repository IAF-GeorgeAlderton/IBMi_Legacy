/** ALMC11 ************************************************/
/*  CALL ALMR11                                           */
/*                                                        */
/* TCHK  08/04/14 CREATE                                  */
/**********************************************************/
             PGM

         OVRDBF    FILE(ALMPL01) TOFILE(TFILE1/ALMPL01)
         OVRDBF    FILE(ALMPL02) TOFILE(TFILE1/ALMPL02)
         OVRDBF    FILE(ALMPL03) TOFILE(TFILE1/ALMPL03)
         OVRDBF    FILE(ALMPP11) TOFILE(TFILE1/ALMPP11)
         OVRDBF    FILE(ALMPL11) TOFILE(TFILE1/ALMPL11)
         OVRDBF    FILE(AB#PPCT) TOFILE(TFILE1/AB#PPCT)

         OVRDBF    FILE(ALMPW01) TOFILE(HOBJ1/ALMPW01)

             CALL       PGM(ALMR11) PARM(' ' ' ' ' ' ' ')
             ENDPGM
