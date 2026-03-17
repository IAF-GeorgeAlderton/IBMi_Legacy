/** ALJC10 ************************************************/
/*  CREFORM MATERIAL SHIP 4-POINT SCAN                    */
/*                                                        */
/* TCHK1 01/10/14 CREATE                                  */
/**********************************************************/
 PGM

             OVRDBF    FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
             OVRDBF    FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
             OVRDBF    FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             CALL      PGM(ALJR10)
             SIGNOFF

 ENDPGM
