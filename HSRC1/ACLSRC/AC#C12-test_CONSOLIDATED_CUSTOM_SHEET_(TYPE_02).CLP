 /** AC#C12 ****************************************************/
 /*  PRINT CONSOLIDATED CUSTOM SHEET (TYPE=02)                 */
 /*                                                            */
 /* J.W.  2017.03.29                                           */
 /**************************************************************/
             PGM        PARM(&NONY &BAR &PRNT &PLT)

             DCL        VAR(&NONY)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&BAR)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&PRNT)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PLT )  TYPE(*CHAR) LEN(3)

             DCL        VAR(&PTYP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PCPY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CTYP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CCPY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LTYP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LCPY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MCPY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SUPP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BMAX) TYPE(*CHAR) LEN(3)
             DCL        VAR(&TRAN) TYPE(*CHAR) LEN(30)
             DCL        VAR(&RTN1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)

/* RETRIEVE PACKING LIST INFORMATION */
             CALL       PGM(UTLR52) PARM(&NONY &PTYP &PCPY &CTYP +
                          &CCPY &CNAM &LTYP &LCPY &MCPY &SUPP &BMAX +
                          &TRAN &RTN1)

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

             OVRPRTF    FILE(QPRINT)  DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&OUTQ) FORMTYPE(K6S1) COPIES(&PCPY)

             CALL       PGM(AC#R12) PARM(&BAR &PLT)

             ENDPGM
