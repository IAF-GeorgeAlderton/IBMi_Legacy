             PGM
             /** AB#C3O **********************************************/
             /*  ..SHIPPER REPORT (HONDA)                            */
             /********************************************** AB#C3O **/
             OVRPRTF    FILE(AB#PR3O) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          120) LPI(6) CPI(15) RPLUNPRT(*YES) +
                          FORMTYPE(K6S1)

             CALL       PGM(AB#R3O)

             DLTOVR     FILE(AB#PR3O)

             ENDPGM
