/** ALMC20 ************************************************/
/*  SB-KRO INPROCESS SCAN DESKTOP                         */
/*                                                        */
/* TCHK  11/11/14 CREATE                                  */
/**********************************************************/
 PGM

         OVRDBF    FILE(ALMPP01) TOFILE(TFILE1/ALMPP01)
         OVRDBF    FILE(ALMPP11) TOFILE(TFILE1/ALMPP11)
         OVRDBF    FILE(AB#PPCT) TOFILE(TFILE1/AB#PPCT)

         OVRDBF    FILE(ALMPW20) TOFILE(HOBJ1/ALMPW20)

         CALL      PGM(ALMR020)

      /* SIGNOFF */

 ENDPGM
