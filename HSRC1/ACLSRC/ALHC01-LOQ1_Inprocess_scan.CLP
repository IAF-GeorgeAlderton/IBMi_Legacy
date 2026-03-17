/** ALHC01 ***************************************************/
/*  LOQ INPROCESS SCAN                                       */
/*                                                           */
/* TCHK  04/02/12 CREATE                                     */
/* LEC   08/02/2019  CHG PRINTOUT TO LASER PRINT WITH B/CODE */
/*************************************************************/
 PGM

             OVRPRTF    FILE(ALHPR02) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) FRONTMGN(.125 0) OVRFLW(66) +
                          RPLUNPRT(*YES) OUTQ(LANPRT27) +
                          FORMTYPE(K6S1) SAVE(*YES) USRDFNDTA('LOQ1 +
                          SCAN')

         CALL      PGM(ALHR01)

         SIGNOFF

 ENDPGM
