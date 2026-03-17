             PGM
             /** ALRC06 *******************************/
             /* 3PT PASSTHRU RETRIEVAL SCAN ERROR LIST*/
             /*    LEC       2016.07.19               */
             /*****************************************/

             OVRPRTF    FILE(QPRINT) PAGESIZE(*N 198) CPI(15) +
                          OUTQ(LANPRT07@) FORMTYPE(K6H1)

             CALL       PGM(ALRR06)

             ENDPGM
