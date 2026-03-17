/** ALHC03 ***************************************************/
/*  LOQ1 INPROCESS SCAN   *TEMP                               */
/*      SAKAKI   2021.11.25                                  */
/*************************************************************/
 PGM

             ADDLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF0000)

             OVRPRTF    FILE(ALHPR02) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) FRONTMGN(.125 0) OVRFLW(66) +
                          RPLUNPRT(*YES) OUTQ(LANPRT27) +
                          FORMTYPE(K6S1) SAVE(*YES) USRDFNDTA('LOQ1 +
                          SCAN') EXPDATE(*DAYS) DAYS(90)

         CALL      PGM(ALHR03)

             RMVLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF0000)

         SIGNOFF

 ENDPGM
