             PGM
             /** ALDC9D *******************************/
             /* FINAL STORAGE IN ERROR LOG LIST       */
             /*    LEC       2016.05.18               */
             /*****************************************/

             OVRPRTF    FILE(QPRINT) PAGESIZE(*N 198) CPI(15) +
                          OUTQ(LANPRT06) FORMTYPE(K6H1)

             CALL       PGM(ALDR9D)

             ENDPGM
