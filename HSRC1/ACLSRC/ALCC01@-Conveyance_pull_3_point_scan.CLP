/** ALCC01 ************************************************/
/*  CONVEYANCE PULL 3-POINT SCAN                          */
/*                                                        */
/* TCHK1 04/21/09 CREATE                                  */
/**********************************************************/
 PGM

             OVRDBF    FILE(ALCPP01) TOFILE(TFILE1/ALCPP01)

/* TCHK6 */  OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
/* TCHK6 */  OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
/* TCHK6 */  OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

/*           OVRDBF    FILE(ALCPW01) TOFILE(TOBJ1/ALCPW01) */

             CALL      PGM(TOBJ1/ALCR01)

/*           SIGNOFF */

 ENDPGM
