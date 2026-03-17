/** ALHC02 ***************************************************/
/*  LOQ2 INPROCESS SCAN                                      */
/*                                                           */
/* TCHK  04/02/12 CREATE                                     */
/* LEC   07/22/2019  CHG PRINTOUT TO LASER PRINT WITH B/CODE */
/*************************************************************/
 PGM

         OVRPRTF    FILE(ALHPR02) DEVTYPE(*AFPDS) PAGESIZE(66 +
                    80) LPI(6) FRONTMGN(.125 0) OVRFLW(66) +
                    RPLUNPRT(*YES) OUTQ(LANPRT28NW) SAVE(*YES) +
                    FORMTYPE(K6S1) USRDFNDTA('LOQ2 SCAN')

         CALL      PGM(ALHR02T)

         SIGNOFF

 ENDPGM
