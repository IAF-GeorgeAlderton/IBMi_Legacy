/** ALGC02 ************************************************/
/*  OQ INPROCESS SCAN - print to laser printer            */
/*                                                        */
/* copy from ALGC01                                       */
/**********************************************************/
 PGM

     /*JW*/
     /*      OVRDBF     FILE(AB#PPCT ) TOFILE(TFILE1/AB#PPCT )     */
     /*      OVRDBF     FILE(ALGPP01 ) TOFILE(TFILE1/ALGPP01 )     */
     /*      OVRDBF     FILE(ALGPP11 ) TOFILE(TFILE1/ALGPP11 )     */

             OVRPRTF    FILE(ALGPR02) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) FRONTMGN(.125 0) OVRFLW(66) +
                          RPLUNPRT(*YES) FORMTYPE(K6S1) SAVE(*YES) +
                          USRDFNDTA('OQ SCAN') EXPDATE(*DAYS) DAYS(90)

             CALL       PGM(ALGR02)

             SIGNOFF

 ENDPGM:     ENDPGM
