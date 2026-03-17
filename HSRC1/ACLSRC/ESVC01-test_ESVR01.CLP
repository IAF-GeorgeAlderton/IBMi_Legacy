/*= ESVC01 ===============================================*/
/*  PROGRAM    : SAVE AB#WP2I TO AB#WP2IZ                 */
/*  WRITTEN    : 2020/05/28                               */
/*  WRITTEN BY : JW(SRA)                                  */
/*========================================================*/
             PGM

             OVRDBF     FILE(AB#WP2I) TOFILE(AB#WP2I) MBR(XXX)

             CALL       PGM(ESVR01)


             ENDPGM
