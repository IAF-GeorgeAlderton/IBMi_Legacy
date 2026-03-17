             PGM        PARM(&XSIRE &MIX &PRT)

             DCL        VAR(&XSIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MIX)   TYPE(*DEC)  LEN(3 0)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&POUT)  TYPE(*CHAR) LEN(10)

/* SELECT OUTQ */
             IF  COND(&PRT *EQ '1') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT02))
             IF  COND(&PRT *EQ '2') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT07))
             IF  COND(&PRT *EQ '3') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT08))
             IF  COND(&PRT *EQ '4') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT03))
             IF  COND(&PRT *EQ '5') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT04))
             IF  COND(&PRT *EQ '6') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT09))
             IF  COND(&PRT *EQ '7') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT10))
             IF  COND(&PRT *EQ '8') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT05))
             IF  COND(&PRT *EQ '9') THEN(CHGVAR VAR(&POUT) VALUE(QDKT))
             IF  COND(&PRT *EQ 'X') THEN(CHGVAR VAR(&POUT) VALUE(QDKT))
             IF  COND(&PRT *EQ 'Y') THEN(CHGVAR VAR(&POUT) VALUE(EPRINT3))
             IF  COND(&PRT *EQ 'A') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT06))
             IF  COND(&PRT *EQ 'B') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT50))


             OVRPRTF    FILE(AB#PR59) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&POUT) +
                          FORMTYPE(K6S1) COPIES(1)

             CALL       PGM(AB#R59) PARM(&MIX)

/* DOWNLOAD TO PDF */
             IF         COND(&PRT *EQ 'Y') THEN(DO)
             CALL       PGM(SPLC12) PARM(&XSIRE 'AB#PR59' 'N')
             ENDDO

             ENDPGM
