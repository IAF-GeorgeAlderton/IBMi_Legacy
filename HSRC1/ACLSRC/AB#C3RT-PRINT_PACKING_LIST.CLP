             PGM        PARM(&PTYPE &PPICK &PSIRE &PNOHZ &PNOBI +
                          &PWEIG &PORDN &PRT)
             /** AB#C3P **********************************************/
             /*  ..EDI PICK-UP LIST..                                */
             /*  TCH42 ADD PROGRMA FOR 0291  5/23/05                 */
             /* TCHK1 12/26/05 CHG PRINTER CONTROL                   */
             /* TCHK2 01/03/06 CHG REMOVE AMBRAKE(0291)              */
             /* TCHK3 08/26/06 BUG FIX                               */
             /* TCHK4 09/19/06 CHG AWNC PATTERN                      */
             /* TCHK5 11/13/06 ADD TAKATA                            */
             /* TCHK6 01/12/07 CHG PRINTER CONTROL                   */
             /* TCHK7 10/17/07 ADD NAL '02' CONTROL                  */
             /********************************************** AB#C3P **/
             DCL        VAR(&PPICK) TYPE(*DEC) LEN(2)
             DCL        VAR(&PTYPE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PNOHZ) TYPE(*CHAR) LEN(8)
/* TCHK3     DCL        VAR(&PNOBI) TYPE(*DEC) LEN(1) */
/* TCHK3 */  DCL        VAR(&PNOBI) TYPE(*DEC) LEN(2)
             DCL        VAR(&PWEIG) TYPE(*DEC) LEN(3 2)
             DCL        VAR(&PMANI) TYPE(*CHAR) LEN(18)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PORDN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&POUT)  TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&US)

             IF         COND(&PRT *EQ '1') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT02))
             IF         COND(&PRT *EQ '2') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT07))
             IF         COND(&PRT *EQ '3') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT08))
             IF         COND(&PRT *EQ '4') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT03))
             IF         COND(&PRT *EQ '5') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT04))
/* TCHK6                  VALUE(QPRINTA)) */
             IF         COND(&PRT *EQ '6') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT09))
/* TCHK1 */  IF         COND(&PRT *EQ '7') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT10))
/* TCHK1 */  IF         COND(&PRT *EQ '8') THEN(CHGVAR VAR(&POUT) +
                          VALUE(LANPRT05))
/* TCHK1 */  IF         COND(&PRT *EQ '9') THEN(CHGVAR VAR(&POUT) +
                          VALUE(QDKT))


             IF         COND((&PTYPE *EQ '01') *OR +
                             (&PTYPE *EQ '07')) THEN(DO)
/* TCHK4 */  IF         COND(&PSIRE *EQ '0492') THEN(DO)
/* TCHK4 */             CALL    PGM(AB#R95) +
/* TCHK4 */                     PARM(&US &PSIRE &PNOHZ &PNOBI &PMANI)
/* TCHK4 */  ENDDO
             OVRPRTF    FILE(AB#PR3G) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK)
/* TCHK4     CALL       PGM(AB#R3G) PARM(&PWEIG) */
/* TCHK4 */  CALL       PGM(AB#R3G) PARM(&PWEIG &PMANI)
             ENDDO


             IF         COND(&PTYPE *EQ '02' *OR &PTYPE *EQ '09') +
                          THEN(DO)

     /* GET THE MANIFEST NUMBER */
             CALL       PGM(AB#R95) PARM(&US &PSIRE &PNOHZ &PNOBI &PMANI)
/* TCHK2 */  /* TCH42 */
/* TCHK2     IF         COND(&PSIRE *EQ '0291') THEN(DO)                */
/* TCHK2        OVRPRTF    FILE(AB#PR3AA) DEVTYPE(*AFPDS) PAGESIZE(66 + */
/* TCHK2                  80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +        */
/* TCHK2                  OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK)     */
/* TCHK2        CALL PGM(AB#R3AA) PARM(&PWEIG &PMANI &PORDN)            */
/* TCHK2     ENDDO                                                      */
/* TCHK2     ELSE DO                                                    */
/* TCHK7 */  IF         COND(&PSIRE *EQ '0235'  +
                         *OR &PSIRE *EQ '0271'  +
                         *OR &PSIRE *EQ '0275'  +
                         *OR &PSIRE *EQ '0276') THEN(DO)
                OVRPRTF    FILE(AB#PR3AB) DEVTYPE(*AFPDS) +
                          PAGESIZE(66 80) LPI(6) +
                          OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK)
                CALL PGM(AB#R3A2) PARM(&PWEIG &PMANI &PORDN)
             ENDDO
             ELSE DO
                OVRPRTF    FILE(AB#PR3A) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK)
/* TCHK5 */  IF         COND(&PSIRE *EQ '3656'  +
                         *OR &PSIRE *EQ '3682'  +
                         *OR &PSIRE *EQ '3712'  +
                         *OR &PSIRE *EQ '3713'  +
                         *OR &PSIRE *EQ '3824'  +
                         *OR &PSIRE *EQ '3842') THEN(DO)
                CALL PGM(AB#R3A1) PARM(&PWEIG &PMANI &PORDN)
             ENDDO
             ELSE DO
                CALL PGM(AB#R3A) PARM(&PWEIG &PMANI &PORDN)
             ENDDO
/* TCHK2     ENDDO                                                      */
/* TCHK7 */  ENDDO

             ENDDO

             IF         COND(&PTYPE *EQ '03') THEN(DO)
             OVRPRTF    FILE(AB#PR3C) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK)
             OVRPRTF    FILE(AB#PR3D) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK)
             OVRPRTF    FILE(AB#PR3E) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK)
             OVRPRTF    FILE(AB#PR3F) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK)
             IF         COND(&PSIRE *EQ '0873' *OR &PSIRE *EQ '0870' +
                          *OR &PSIRE *EQ '3764' *OR &PSIRE *EQ '0701' +
                          *OR &PSIRE *EQ '0871') +
                          THEN(CALL PGM(AB#R3MT) PARM(&PWEIG &PTYPE))
             IF         COND(&PSIRE *NE '0873' *AND &PSIRE *NE +
                          '0870' *AND &PSIRE *NE '3347' *AND &PSIRE +
                          *NE '3764' *AND &PSIRE *NE '0701' *AND +
                          &PSIRE *NE '0871') THEN(CALL PGM(AB#R3CT) +
                          PARM(&PWEIG &PTYPE))
             IF         COND(&PSIRE *EQ '3347') THEN(CALL +
                          PGM(AB#R3FT) PARM(&PWEIG &PTYPE))
             ENDDO


             IF         COND(&PTYPE *GE '04' *AND &PTYPE *LE '06') +
                          THEN(DO)

             OVRPRTF    FILE(AB#PR3C) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK)
             OVRPRTF    FILE(AB#PR3D) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK)
             OVRPRTF    FILE(AB#PR3E) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK)
             OVRPRTF    FILE(AB#PR3F) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK)

             CALL       PGM(AB#R3DT) PARM(&PWEIG &PTYPE)

             ENDDO


             IF         COND(&PTYPE *EQ '08') THEN(DO)
             OVRPRTF    FILE(AB#PR3J) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK)
             CALL       PGM(AB#R3J) PARM(&PWEIG)
             ENDDO


             IF         COND(&PTYPE *EQ '10') THEN(DO)

             CALL       PGM(AB#R95) PARM(&US &PSIRE &PNOHZ &PNOBI &PMANI)

             OVRPRTF    FILE(AB#PR3R) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK)
/* TCHK5 */  IF         COND(&PSIRE *EQ '3656'  +
                         *OR &PSIRE *EQ '3682'  +
                         *OR &PSIRE *EQ '3712'  +
                         *OR &PSIRE *EQ '3713'  +
                         *OR &PSIRE *EQ '3824'  +
                         *OR &PSIRE *EQ '3842') THEN(DO)
             CALL       PGM(AB#R3R1) PARM(&PWEIG &PMANI &PORDN)
             ENDDO
             ELSE DO
             CALL       PGM(AB#R3R) PARM(&PWEIG &PMANI &PORDN)
             ENDDO
             ENDDO

 END:        ENDPGM
