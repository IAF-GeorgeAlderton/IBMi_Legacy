/** ALLC11 ************************************************/
/*  CALL ALLR11                                           */
/*                                                        */
/* TCHK  07/31/14 CREATE                                  */
/**********************************************************/
             PGM

         OVRDBF    FILE(ALLPL01) TOFILE(TFILE1/ALLPL01)
         OVRDBF    FILE(ALLPL02) TOFILE(TFILE1/ALLPL02)
         OVRDBF    FILE(ALLPL03) TOFILE(TFILE1/ALLPL03)
         OVRDBF    FILE(ALLPP11) TOFILE(TFILE1/ALLPP11)
         OVRDBF    FILE(ALLPL11) TOFILE(TFILE1/ALLPL11)
         OVRDBF    FILE(AB#PPCT) TOFILE(TFILE1/AB#PPCT)

         OVRDBF    FILE(ALLPW01) TOFILE(HOBJ1/ALLPW01)

             CALL       PGM(ALLR11) PARM(' ' ' ' ' ' ' ')
             ENDPGM
