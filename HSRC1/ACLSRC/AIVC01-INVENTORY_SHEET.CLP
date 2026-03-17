             PGM
             /*** AIVC01 ***********************************/
             /* INVENTORY DATA FOR PC                      */
             /*           TCH                              */
             /* TCHK1 04/24/06 CHG STOP PRINT              */
             /*********************************** AIVC01 ***/
             CLRPFM AIVWP01
             CLRPFM AIVWP02
             CLRPFM AIVWP03
             CLRPFM AIVWP04
             CLRPFM AIVWP05

/* TCHK1     OVRPRTF    FILE(QPRINT) PAGESIZE(66 80) LPI(6) +
                          OVRFLW(60) RPLUNPRT(*YES) OUTQ(LANPRT04) +
                          FORMTYPE(K6S1) */
             CALL AIVR01


             ENDPGM
