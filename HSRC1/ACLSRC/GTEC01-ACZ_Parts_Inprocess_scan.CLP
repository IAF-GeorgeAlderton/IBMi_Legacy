/** GTEC01 ************************************************/
/*  ACZ PARTS INPROCESS SCAN                              */
/*                                                        */
/* TCHK1 11/27/12 CREATE                                  */
/**********************************************************/
 PGM

             OVRDBF    FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
             OVRDBF    FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
             OVRDBF    FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             CALL      PGM(GTER01)
             SIGNOFF

 ENDPGM
