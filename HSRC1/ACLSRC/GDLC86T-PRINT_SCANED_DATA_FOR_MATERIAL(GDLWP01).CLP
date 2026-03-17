             PGM
             /** GDLC86 *************************/
             /*  PRINT SCANED DATA FOR MATERIAL */
             /*  N.HYOTO 2001.06.14             */
             /***********************************/
             OVRPRTF    FILE(QPRINT) PAGESIZE(66 80) OUTQ(SAKAKI) +
                          FORMTYPE(K6S1) HOLD(*NO)

             CALL       PGM(GDLR06T)

             DLTOVR     FILE(*ALL)

 END:        ENDPGM
