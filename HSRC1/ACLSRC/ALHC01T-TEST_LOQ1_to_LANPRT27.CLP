/*************************************************************/
/*  TEST LOQ INPROCESS SCAN                                  */
/*                                                           */
/* LEC   07/22/2019                                          */
/*************************************************************/
 PGM

             OVRPRTF    FILE(ALHPR02) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) FRONTMGN(.125 0) OVRFLW(66) +
                          RPLUNPRT(*YES) OUTQ(LANPRT03) +
                          FORMTYPE(K6S1) HOLD(*YES) SAVE(*YES) +
                          USRDFNDTA('LOQ1 SCAN')

             CALL       PGM(TOBJ1/ALHR01)

         SIGNOFF

 ENDPGM
