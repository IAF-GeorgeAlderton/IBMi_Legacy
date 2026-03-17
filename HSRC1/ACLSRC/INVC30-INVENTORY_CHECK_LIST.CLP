             PGM
             /***INVC30 ****************************************/
             /* INVENTORY CHECK LIST                           */
             /*************************************** IZAC01 ***/


             OVRPRTF    FILE(QPRINT) PAGESIZE(66 80) LPI(6) +
                          OUTQ(LANPRT04) FORMTYPE(K6S1)
             CALL       PGM(INVR30)

             ENDPGM
