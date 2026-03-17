             PGM
/** AFAC88 ************************************************/
/*  3 BOND INVENTORY CHECK SHEET CREATE                   */
/*                                                        */
/* TCHK  05/10/12 CREATE                                  */
/**********************************************************/

             CLRPFM     FILE(HWFILE1/AFAWP88)
             OVRDBF     FILE(AFAWP88) TOFILE(HWFILE1/AFAWP88)
             OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             CALL       PGM(AFAR88)

             ENDPGM
