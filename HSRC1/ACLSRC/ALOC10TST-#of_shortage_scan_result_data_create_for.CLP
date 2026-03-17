/** ALOC10 ************************************************/
/*  #OF SHORTAGE SCAN                                     */
/*                                                        */
/* TCHK  10/07/14 CREATE                                  */
/**********************************************************/
 PGM

/* tt */ OVRPRTF   FILE(QPRINT) OUTQ(QDKT)

         OVRDBF    FILE(ALOWP10) TOFILE(HWFILE1/ALOWP10)
         CLRPFM    HWFILE1/ALOWP10

         CALL      PGM(TOBJ1/ALOR10)

 ENDPGM
