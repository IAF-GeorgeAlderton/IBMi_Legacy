/** GTAC00 ************************************************/
/*  ACZ SHIPPING CONTROL                                  */
/*                                                        */
/* TCHK  11/20/12 CREATE                                  */
/**********************************************************/
 PGM

             OVRDBF    FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
             OVRDBF    FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
             OVRDBF    FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             CALL      PGM(GTAR00)
             SIGNOFF

 ENDPGM
