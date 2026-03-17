/** ALLC01 ************************************************/
/*  LAN/AOQ INPROCESS SCAN                                */
/*                                                        */
/* TCHK  07/21/11 CREATE                                  */
/**********************************************************/
 PGM

         OVRDBF    FILE(ALLPP01) TOFILE(TFILE1/ALLPP01)
         OVRDBF    FILE(ALLPP11) TOFILE(TFILE1/ALLPP11)
         OVRDBF    FILE(AB#PPCT) TOFILE(TFILE1/AB#PPCT)

         OVRDBF    FILE(ALLPW01) TOFILE(HOBJ1/ALLPW01)

         CALL      PGM(HOBJ1/ALLR01)
/*       SIGNOFF */

 ENDPGM
