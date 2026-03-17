/** ALOC10 ************************************************/
/*  #OF SHORTAGE SCAN                                     */
/*                                                        */
/* TCHK  10/07/14 CREATE                                  */
/**********************************************************/
 PGM

/*JW     OVRPRTF   FILE(QPRINT) OUTQ(LANPRT06) */
         OVRPRTF   FILE(QPRINT) OUTQ(LANPRT08)

         OVRDBF    FILE(ALOWP10) TOFILE(HWFILE1/ALOWP10)
         CLRPFM    HWFILE1/ALOWP10

         CALL      PGM(ALOR10)

 ENDPGM
