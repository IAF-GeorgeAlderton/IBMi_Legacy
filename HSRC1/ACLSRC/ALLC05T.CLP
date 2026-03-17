/** ALLC05 ************************************************/
/*  LAN/AOQ INPROCESS SCAN                                */
/*                                                        */
/* TCHK  07/31/11 CREATE                                  */
/**********************************************************/
 PGM

         OVRDBF    FILE(ALLPL02) TOFILE(TFILE1/ALLPL02)
         OVRDBF    FILE(ALLPP11) TOFILE(TFILE1/ALLPP11)
         OVRDBF    FILE(AB#PPCT) TOFILE(TFILE1/AB#PPCT)

         OVRDBF    FILE(ALLPW05) TOFILE(HOBJ1/ALLPW05)

         CALL      PGM(HOBJ1/ALLR05)
/*       SIGNOFF */

 ENDPGM
