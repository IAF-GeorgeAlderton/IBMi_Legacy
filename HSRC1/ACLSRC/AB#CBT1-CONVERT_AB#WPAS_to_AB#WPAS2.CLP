             PGM
/** AB#CBT1 ***********************************************/
/*  CONVERT AB#WPAS TO AB#WPAS2                           */
/*  J.WATANABE    2021.06.16                              */
/**********************************************************/

             OVRDBF     FILE(AB#WPAQ)  TOFILE(QTEMP/AB#WPAQ)
             OVRDBF     FILE(AB#WPAT)  TOFILE(QREMP/AB#WPAT)

             CALL       PGM(AB#RBT1)

             ENDPGM
