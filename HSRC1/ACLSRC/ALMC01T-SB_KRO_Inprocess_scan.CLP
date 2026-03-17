/** ALMC01 ************************************************/
/*  SB-KRO INPROCESS SCAN                                 */
/*                                                        */
/* TCHK  08/04/14 CREATE                                  */
/**********************************************************/
 PGM

         OVRDBF    FILE(ALMPP01) TOFILE(TFILE1/ALMPP01)
         OVRDBF    FILE(ALMPP11) TOFILE(TFILE1/ALMPP11)
         OVRDBF    FILE(AB#PPCT) TOFILE(TFILE1/AB#PPCT)

         OVRDBF    FILE(ALMPW01) TOFILE(HOBJ1/ALMPW01)

         CALL      PGM(ALMR01)

      /* SIGNOFF */

 ENDPGM
