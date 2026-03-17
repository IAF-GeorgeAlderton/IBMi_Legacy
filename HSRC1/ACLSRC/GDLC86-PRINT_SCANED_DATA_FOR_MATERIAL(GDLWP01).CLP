             PGM
             /** GDLC86 *************************/
             /*  PRINT SCANED DATA FOR MATERIAL */
             /*  N.HYOTO 2001.06.14             */
             /***********************************/
             OVRPRTF    FILE(QPRINT) PAGESIZE(66 80) OUTQ(LANPRT02) +
                          FORMTYPE(K6S1) HOLD(*NO)

       /*    RUNQRY     QRY(HOBJ1/QGDLWP01) RCDSLT(*YES) */
             CALL       PGM(GDLR06)

             DLTOVR     FILE(*ALL)

 END:        ENDPGM
