/** MRHC55 ************************************************/
/*  CHECK GATE SCAN                                       */
/*                                                        */
/* TCHK1 05/09/14 CREATE                                  */
/**********************************************************/
 PGM

             OVRDBF    FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
             OVRDBF    FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
             OVRDBF    FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             CALL      PGM(MRHR55)
             SIGNOFF

 ENDPGM
