             PGM        PARM(&XSIRE &PRT)
             /** AB#C3O **********************************************/
             /*  ..SHIPPER REPORT (HONDA)                            */
             /*                                                      */
             /* TCHK1 12/26/05 CHG PRINTER CONTROL                   */
             /* TCHK2 01/12/07 CHG PRINTER CONTROL                   */
             /********************************************** AB#C3O **/
             DCL        VAR(&XSIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&POUT)  TYPE(*CHAR) LEN(10)

             IF   COND(&PRT *EQ '1') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT02))
             IF   COND(&PRT *EQ '2') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT07))
             IF   COND(&PRT *EQ '3') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT08))
             IF   COND(&PRT *EQ '4') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT03))
             IF   COND(&PRT *EQ '5') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT04))
             IF   COND(&PRT *EQ '6') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT09))
             IF   COND(&PRT *EQ '7') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT10))
             IF   COND(&PRT *EQ '8') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT05))
             IF   COND(&PRT *EQ '9') THEN(CHGVAR VAR(&POUT) VALUE(QDKT))
             IF   COND(&PRT *EQ 'X') THEN(CHGVAR VAR(&POUT) VALUE(QDKT))
 /*JW*/      IF   COND(&PRT *EQ 'Y') THEN(CHGVAR VAR(&POUT) VALUE(EPRINT3 ))
             IF   COND(&PRT *EQ 'A') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT06))
             IF   COND(&PRT *EQ 'B') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT50))

             OVRPRTF    FILE(AB#PR3O) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          120) LPI(6) CPI(15) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1)

             CALL       PGM(AB#R3O)

/* DOWNLOAD TO PDF */
             IF         COND(&PRT *EQ 'Y') THEN(DO)
             CALL       PGM(SPLC13) PARM(&XSIRE 'AB#PR3O' 'N')
             ENDDO

             DLTOVR     FILE(AB#PR3O)

             ENDPGM
