/** ALHC01 ************************************************/
/*  LOQ INPROCESS SCAN                                    */
/*                                                        */
/* TCHK  04/02/12 CREATE                                  */
/**********************************************************/
 PGM

         OVRPRTF   FILE(ALHPR01) OUTQ(LANPRT27) SAVE(*YES)

         CALL      PGM(ALHR01)

         SIGNOFF

 ENDPGM
