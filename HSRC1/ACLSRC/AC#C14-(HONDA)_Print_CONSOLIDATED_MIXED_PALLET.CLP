             PGM        PARM(&BAR &PRNT &MIX)

             DCL        VAR(&BAR ) TYPE(*CHAR) LEN(9)
             DCL        VAR(&PRNT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MIX)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)

/* DEFINE OUTQ */
             IF  COND(&PRNT *EQ '1') THEN(CHGVAR VAR(&OUTQ) VALUE(LANPRT02))
             IF  COND(&PRNT *EQ '2') THEN(CHGVAR VAR(&OUTQ) VALUE(LANPRT07))
             IF  COND(&PRNT *EQ '3') THEN(CHGVAR VAR(&OUTQ) VALUE(LANPRT08))
             IF  COND(&PRNT *EQ '4') THEN(CHGVAR VAR(&OUTQ) VALUE(LANPRT03))
             IF  COND(&PRNT *EQ '5') THEN(CHGVAR VAR(&OUTQ) VALUE(LANPRT04))
             IF  COND(&PRNT *EQ '6') THEN(CHGVAR VAR(&OUTQ) VALUE(LANPRT09))
             IF  COND(&PRNT *EQ '7') THEN(CHGVAR VAR(&OUTQ) VALUE(LANPRT10))
             IF  COND(&PRNT *EQ '8') THEN(CHGVAR VAR(&OUTQ) VALUE(LANPRT05))
             IF  COND(&PRNT *EQ '9') THEN(CHGVAR VAR(&OUTQ) VALUE(QDKT    ))

/* CREATE WORK FILE */
             CALL       PGM(AC#C20) PARM(&BAR)

             OVRPRTF    FILE(AC#PR14) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&OUTQ) +
                          FORMTYPE(K6S1) COPIES(1)

             CALL       PGM(AC#R14) PARM(&MIX)

             ENDPGM
