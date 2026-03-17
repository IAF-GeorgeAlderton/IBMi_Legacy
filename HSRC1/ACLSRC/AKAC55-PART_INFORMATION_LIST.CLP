             PGM
             /** AKAC55 ********************************/
             /*  PART INFORMATION LIST               */
             /*                                        */
             /******************************** AKAC55 **/
             OVRPRTF    FILE(QPRINT) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(LANPRT02) +
                          FORMTYPE(K6S1)

             CALL       PGM(AKAR55)
             DLTOVR     FILE(*ALL)

             ENDPGM
