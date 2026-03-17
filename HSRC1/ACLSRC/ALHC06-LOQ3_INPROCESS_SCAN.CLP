/** ALHC06 ***************************************************/
/*  LOQ3 INPROCESS SCAN                                      */
/*                                                           */
/*   COPY FROM ALHC04   2022/05/06                           */
/*************************************************************/
 PGM

             ADDLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF0000)

             OVRPRTF    FILE(ALHPR02) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) FRONTMGN(.125 0) OVRFLW(66) +
                          RPLUNPRT(*YES) OUTQ(LANPRT38) +
                          FORMTYPE(K6S1) SAVE(*YES) USRDFNDTA('LOQ3 +
                          SCAN') EXPDATE(*DAYS) DAYS(90)

         CALL      PGM(ALHR06)

             RMVLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF0000)

         SIGNOFF

 ENDPGM
