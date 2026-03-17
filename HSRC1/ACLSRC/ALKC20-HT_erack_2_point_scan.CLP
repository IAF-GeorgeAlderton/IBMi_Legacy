/** ALKC20 ************************************************/
/*  HT ERACK 2 POINT SCAN                                 */
/*                                                        */
/* TCHK1 06/12/14 CREATE                                  */
/**********************************************************/
 PGM

             OVRDBF    FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
             OVRDBF    FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
             OVRDBF    FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             CALL      PGM(ALKR20)
             SIGNOFF

 ENDPGM
