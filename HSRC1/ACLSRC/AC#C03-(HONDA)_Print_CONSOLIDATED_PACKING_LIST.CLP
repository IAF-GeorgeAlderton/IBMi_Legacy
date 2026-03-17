             PGM        PARM(&BAR &NONY &ODRN &CWGT &MAN# &PRNT &NOHZ &RTN)
             /** AC#C03 **********************************************/
             /*  (HONDA) PRINT CONSOLIDATED PACKING LIST             */
             /*  (COPIED FROM AB#C3R)                                */
             /*  JW  2017.03.23                                      */
             /********************************************************/
             DCL        VAR(&BAR )  TYPE(*CHAR) LEN(9)
             DCL        VAR(&NONY)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&ODRN)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&CWGT)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&MAN#)  TYPE(*CHAR) LEN(18)
             DCL        VAR(&PRNT)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&NOHZ)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN )  TYPE(*CHAR) LEN(1)
             DCL        VAR(&MAN95) TYPE(*CHAR) LEN(18)

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)

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

             RTVJOBA    JOB(&WSID) USER(&USR)

/* RETRIEVE PACKING LIST INFORMATION */
             CALL       PGM(UTLR52) PARM(&NONY &PTYP &PCPY &CTYP +
                          &CCPY &CNAM &LTYP &LCPY &MCPY &SUPP &BMAX +
                          &TRAN &RTN1)

/* CREATE WORK FILE */
             CLRPFM     FILE(*LIBL/AC#PP32)
             CALL       PGM(AC#R20) PARM(&BAR)

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

/*=== TYPE 01, 07 ===*/
             IF  COND((&PTYP='01') *OR (&PTYP='07')) THEN(DO)

          /* NOT HONDA                                                  */
          /* IF  COND(&NONY *EQ '0492') THEN(DO)                        */
          /*     CALL    PGM(AC#C95) PARM(&BAR &USR &NONY &NOHZ &MAN95) */
          /*     CHGVAR     VAR(&MAN#) VALUE(&MAN95)                    */
          /* ENDDO                                                      */

             OVRPRTF    FILE(AC#PR04) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&OUTQ) FORMTYPE(K6S1) COPIES(&PCPY)

             CALL       PGM(AC#R04) PARM(&BAR &ODRN &CWGT &MAN# &PTYP &RTN)
             GOTO       CMDLBL(END)
             ENDDO

 /*=== PACKING LIST TYPE ="02" OR "09" ===*/
             IF    COND(&PTYP='02' *OR &PTYP='09') THEN(DO)

     /* GET THE MANIFEST NUMBER */
             CALL    PGM(AC#C95) PARM(&BAR &USR &NONY &NOHZ &MAN95)
             CHGVAR     VAR(&MAN#) VALUE(&MAN95)

       /* NOT HONDA                                                           */
       /*    IF    COND(&NONY *EQ '0235' *OR &NONY *EQ '0271'  +            */
       /*           *OR &NONY *EQ '0275' *OR &NONY *EQ '0276') THEN(DO)     */
       /*    OVRPRTF  FILE(AB#PR3AB) DEVTYPE(*AFPDS) PAGESIZE(66 80) LPI(6) + */
       /*             OVRFLW(60) RPLUNPRT(*YES) OUTQ(&OUTQ) FORMTYPE(K6S1) +  */
       /*             COPIES(&PCPY)                                         */
       /*    CALL PGM(AB#R3A2) PARM(&PWEIG &PMANI &PORDN)                    */
       /*    ENDDO                                                           */
       /*                                                                    */
       /*    ELSE DO                                                         */

             OVRPRTF  FILE(AC#PR05) DEVTYPE(*AFPDS) PAGESIZE(66 80) LPI(6) +
                      OVRFLW(60) RPLUNPRT(*YES) OUTQ(&OUTQ) FORMTYPE(K6S1) +
                      COPIES(&PCPY)

             CALL     PGM(AC#R05) PARM(&BAR &ODRN &CWGT &MAN# &PTYP &RTN)

        /*   ENDDO                                                           */
        /*   ENDDO                                                           */
             ENDDO

 /*=== PACKING LIST TYPE ="03" ===*/
             IF         COND(&PTYP='03') THEN(DO)

       /*    OVRPRTF    FILE(AB#PR3C) DEVTYPE(*AFPDS) PAGESIZE(66 +     */
       /*                 80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +        */
       /*                 OUTQ(&OUTQ) FORMTYPE(K6S1) COPIES(&PCPY)      */
       /*    OVRPRTF    FILE(AB#PR3D) DEVTYPE(*AFPDS) PAGESIZE(66 +     */
       /*                 80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +        */
       /*                 OUTQ(&OUTQ) FORMTYPE(K6S1) COPIES(&PCPY)      */
       /*    OVRPRTF    FILE(AB#PR3E) DEVTYPE(*AFPDS) PAGESIZE(66 +     */
       /*                 80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +        */
       /*                 OUTQ(&OUTQ) FORMTYPE(K6S1) COPIES(&PCPY)      */
       /*    OVRPRTF    FILE(AB#PR3F) DEVTYPE(*AFPDS) PAGESIZE(66 +     */
       /*                 80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +        */
       /*                 OUTQ(&OUTQ) FORMTYPE(K6S1) COPIES(&PCPY)      */
       /*    IF         COND(&NONY *EQ '0873' *OR &NONY *EQ '0870' +    */
       /*                 *OR &NONY *EQ '3764' *OR &NONY *EQ '0701' +   */
       /*                 *OR &NONY *EQ '0871' *OR &NONY *EQ '0876') +  */
       /*               THEN(CALL PGM(AB#R3M) PARM(&PWEIG &PTYPE))      */

             OVRPRTF    FILE(AC#PR06) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&OUTQ) FORMTYPE(K6S1) COPIES(&PCPY)

             IF         COND(&NONY *NE '0873' *AND &NONY *NE +
                          '0870' *AND &NONY *NE '3347' *AND &NONY +
                          *NE '3764' *AND &NONY *NE '0701' *AND +
                          &NONY *NE '0871' *AND &NONY *NE '0876') +
             THEN(CALL PGM(AC#R06) PARM(&BAR &ODRN &CWGT &MAN# &RTN))

       /*    IF         COND(&NONY *EQ '3347') THEN(CALL +         */
       /*                 PGM(AB#R3F) PARM(&PWEIG &PTYPE))          */
             ENDDO


 /*=== PACKING LIST TYPE ="04", "05 OR "06" ===*/
             IF  COND(&PTYP='04' *OR &PTYP='05' *OR &PTYP='06') THEN(DO)

             OVRPRTF    FILE(AC#PR07) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&OUTQ) FORMTYPE(K6S1) COPIES(&PCPY)
             OVRPRTF    FILE(AC#PR08) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&OUTQ) FORMTYPE(K6S1) COPIES(&PCPY)
             OVRPRTF    FILE(AC#PR09) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&OUTQ) FORMTYPE(K6S1) COPIES(&PCPY)

    /*       CALL       PGM(AB#R3D) PARM(&PWEIG &PTYPE)    */
             CALL       PGM(AC#R07) PARM(&BAR &ODRN &CWGT &MAN# &PTYP &RTN)

             ENDDO


 /*=== PACKING LIST TYPE ="08" ===*/
             IF         COND(&PTYP='08') THEN(DO)
             OVRPRTF    FILE(AC#PR10) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&OUTQ) FORMTYPE(K6S1) COPIES(&PCPY)
          /* CALL       PGM(AB#R3J) PARM(&PWEIG)   */
             CALL       PGM(AC#R08) PARM(&BAR &ODRN &CWGT &MAN# &RTN)
             ENDDO


/*=== TYPE 10 ===*/
             IF  COND(&PTYP='10') THEN(DO)
                 CALL    PGM(AC#C95) PARM(&BAR &USR &NONY &NOHZ &MAN95)
                 CHGVAR     VAR(&MAN#) VALUE(&MAN95)

             OVRPRTF    FILE(AC#PR03) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&OUTQ) FORMTYPE(K6S1) COPIES(&PCPY)
             CALL       PGM(AC#R03) PARM(&BAR &ODRN &CWGT &MAN# &RTN)
             GOTO       CMDLBL(END)
             ENDDO

 END:        ENDPGM
