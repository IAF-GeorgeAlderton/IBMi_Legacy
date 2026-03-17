/** ALKC01 ************************************************/
/*  HT PULL 3-POINT SCAN                                  */
/*                                                        */
/* TCHK1 06/11/14 CREATE                                  */
/**********************************************************/
 PGM

             OVRDBF    FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
             OVRDBF    FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
             OVRDBF    FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             CALL      PGM(ALKR01)
             SIGNOFF

 ENDPGM
