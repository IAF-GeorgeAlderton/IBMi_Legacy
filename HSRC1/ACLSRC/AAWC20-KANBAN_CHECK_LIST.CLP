             PGM
             /** AAWC20 ************************************/
             /* KANBAN CHECK LIST                                      */
             /*          TCH            2002.10.01         */
             /**********************************************/
             OVRPRTF    FILE(QPRINT) PAGESIZE(*N 198) CPI(15) +
                          FORMTYPE(K6H1)
             CALL       PGM(AAWR20)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM
