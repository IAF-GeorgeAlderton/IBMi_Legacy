             PGM        PARM(&PTYPE &PPICK &PSIRE &PNOHZ &PNOBI +
                          &PWEIG &PORDN &PRT)
             /** AB#C3X **********************************************/
             /*  ..EDI PICK-UP LIST..                                */
             /********************************************** AB#C3X **/
             DCL        VAR(&PPICK) TYPE(*DEC) LEN(2)
             DCL        VAR(&PTYPE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PNOHZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PNOBI) TYPE(*DEC) LEN(2)
             DCL        VAR(&PWEIG) TYPE(*DEC) LEN(3 2)
             DCL        VAR(&PMANI) TYPE(*CHAR) LEN(18)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PORDN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&POUT)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDT)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&PBN)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&PALL) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&US)

             CHGVAR     VAR(&POUT) VALUE(YAJIMA)
             CHGVAR     VAR(&PPICK) VALUE(1)

             CHGVAR     VAR(&PDT) VALUE(%SUBSTRING(&PNOHZ 5 4))
             CHGVAR     VAR(&PBN) VALUE(&PNOBI)
             CHGVAR     VAR(&PALL) VALUE(&PSIRE *TCAT &PDT *TCAT &PBN)

    /* NEW PACKING LIST */
             OVRPRTF    FILE(AB#PR3K) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK) +
                          HOLD(*YES) USRDTA(&PALL) EXPDATE(*DAYS) +
                          DAYS(14)
             CALL       PGM(AB#R30)

/*=== PACKING LIST TYPE ="01" OR "07" ---SNDNETSPLF ===*/
             IF         COND((&PTYPE *EQ '01') *OR +
                             (&PTYPE *EQ '07')) THEN(DO)
             IF         COND(&PSIRE *EQ '0492') THEN(DO)
                        CALL    PGM(AB#R95) +
                                PARM(&US &PSIRE &PNOHZ &PNOBI &PMANI)
             ENDDO

             OVRPRTF    FILE(AB#PR3G) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK) +
                          HOLD(*YES) USRDTA(&PALL) EXPDATE(*DAYS) +
                          DAYS(14)

             CALL       PGM(AB#R3G) PARM(&PWEIG &PMANI)

             ENDDO

/*=== PACKING LIST TYPE ="02" OR "09" ---SNDNETSPLF ===*/
             IF         COND(&PTYPE *EQ '02' *OR &PTYPE *EQ '09') +
                          THEN(DO)

     /* GET THE MANIFEST NUMBER */
             CALL       PGM(AB#R95) PARM(&US &PSIRE &PNOHZ &PNOBI &PMANI)

             IF         COND(&PSIRE *EQ '0235'  +
                         *OR &PSIRE *EQ '0271'  +
                         *OR &PSIRE *EQ '0275'  +
                         *OR &PSIRE *EQ '0276') THEN(DO)

             OVRPRTF    FILE(AB#PR3AB) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK) +
                          HOLD(*YES) USRDTA(&PALL) EXPDATE(*DAYS) +
                          DAYS(14)
                CALL PGM(AB#R3A2) PARM(&PWEIG &PMANI &PORDN)

             ENDDO

             ELSE DO
             OVRPRTF    FILE(AB#PR3A) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK) +
                          HOLD(*YES) USRDTA(&PALL) EXPDATE(*DAYS) +
                          DAYS(14)

             IF         COND(&PSIRE *EQ '3656'  +
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

             ENDDO
             ENDDO

/*=== PACKING LIST TYPE ="03" ---SNDNETSPLF ===*/
             IF         COND(&PTYPE *EQ '03') THEN(DO)

             OVRPRTF    FILE(AB#PR3C) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK) +
                          HOLD(*YES) USRDTA(&PALL) EXPDATE(*DAYS) +
                          DAYS(14)

             IF         COND(&PSIRE *EQ '0873' *OR &PSIRE *EQ '0870' +
                          *OR &PSIRE *EQ '3764' *OR &PSIRE *EQ +
                          '0871' *OR &PSIRE *EQ '0876') THEN(CALL +
                          PGM(AB#R3M) PARM(&PWEIG &PTYPE))
             IF         COND(&PSIRE *NE '0873' *AND &PSIRE *NE +
                          '0870' *AND &PSIRE *NE '3347' *AND &PSIRE +
                          *NE '3764' *AND &PSIRE *NE '0871' *AND +
                          &PSIRE *NE '0876') THEN(CALL PGM(AB#R3C) +
                          PARM(&PWEIG &PTYPE))
             IF         COND(&PSIRE *EQ '3347') THEN(CALL +
                          PGM(AB#R3F) PARM(&PWEIG &PTYPE))

             ENDDO

/*=== PACKING LIST TYPE ="04" --- SNDNETSPLF ===*/
             IF         COND(&PTYPE *EQ '04') THEN(DO)
             OVRPRTF    FILE(AB#PR3D) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK) +
                          HOLD(*YES) USRDTA(&PALL) EXPDATE(*DAYS) +
                          DAYS(14)

             CALL       PGM(AB#R3D) PARM(&PWEIG &PTYPE)

             ENDDO

/*=== PACKING LIST TYPE ="05" --- SNDNETSPLF ===*/
             IF         COND(&PTYPE *EQ '05') THEN(DO)
             OVRPRTF    FILE(AB#PR3E) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK) +
                          HOLD(*YES) USRDTA(&PALL) EXPDATE(*DAYS) +
                          DAYS(14)

             CALL       PGM(AB#R3D) PARM(&PWEIG &PTYPE)

             ENDDO

/*=== PACKING LIST TYPE ="06" --- SNDNETSPLF ===*/
             IF         COND(&PTYPE *EQ '06') THEN(DO)
             OVRPRTF    FILE(AB#PR3F) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK) +
                          HOLD(*YES) USRDTA(&PALL) EXPDATE(*DAYS) +
                          DAYS(14)

             CALL       PGM(AB#R3D) PARM(&PWEIG &PTYPE)

             ENDDO


/*=== PACKING LIST TYPE ="08" --- SNDNETSPLF ===*/
             IF         COND(&PTYPE *EQ '08') THEN(DO)

             OVRPRTF    FILE(AB#PR3J) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK) +
                          HOLD(*YES) USRDTA(&PALL) EXPDATE(*DAYS) +
                          DAYS(14)
             CALL       PGM(AB#R3J) PARM(&PWEIG)

             ENDDO


/*=== PACKING LIST TYPE ="10" --- SNDNETSPLF ===*/
             IF         COND(&PTYPE *EQ '10') THEN(DO)
             CALL       PGM(AB#R95) PARM(&US &PSIRE &PNOHZ &PNOBI &PMANI)

             OVRPRTF    FILE(AB#PR3R) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK) +
                          HOLD(*YES) USRDTA(&PALL) EXPDATE(*DAYS) +
                          DAYS(14)

             IF         COND(&PSIRE *EQ '3656'  +
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

             CLRPFM QTEMP/AB#WP37
             MONMSG     MSGID(CPF0000)

 END:        ENDPGM
