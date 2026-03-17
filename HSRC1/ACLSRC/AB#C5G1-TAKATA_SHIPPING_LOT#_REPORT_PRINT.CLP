/** AB#C5G1  **********************************************/
/*  TAKATA SHIPPING LOT# REPORT PRINT                     */
/*                                                        */
/* TCHK1 12/26/05 CHG PRINTER CONTROL                     */
/**********************************************************/
PGM     PARM(&PSIRE &PSIRK &PDOCK &PNOHZ &PNOBI &PCOPY &PPRNT)

        DCL     VAR(&PSIRE) TYPE(*CHAR) LEN(4)
        DCL     VAR(&PSIRK) TYPE(*CHAR) LEN(1)
        DCL     VAR(&PDOCK) TYPE(*CHAR) LEN(4)
        DCL     VAR(&PNOHZ) TYPE(*DEC)  LEN(8)
        DCL     VAR(&PNOBI) TYPE(*DEC)  LEN(2)
        DCL     VAR(&PCOPY) TYPE(*DEC)  LEN(1)
        DCL     VAR(&PPRNT) TYPE(*CHAR) LEN(1)

        DCL     VAR(&POUT)  TYPE(*CHAR) LEN(10)

             IF      COND(&PPRNT *EQ '1') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT02))
             IF      COND(&PPRNT *EQ '2') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT07))
             IF      COND(&PPRNT *EQ '3') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT08))
             IF      COND(&PPRNT *EQ '4') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT03))
             IF      COND(&PPRNT *EQ '5') THEN(CHGVAR VAR(&POUT) +
                          VALUE(QPRINTA))
             IF      COND(&PPRNT *EQ '6') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT09))
             IF      COND(&PPRNT *EQ '7') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT10))
             IF      COND(&PPRNT *EQ '8') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT05))
             IF      COND(&PPRNT *EQ '9') THEN(CHGVAR VAR(&POUT) +
                          VALUE(QDKT))

             OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PCOPY)

             CALL       PGM(AB#R5G1) +
                          PARM(&PSIRE &PSIRK &PDOCK &PNOHZ &PNOBI)

 END:        ENDPGM
