             PGM        PARM(&PTYPE &PPICK &PSIRE &PNOHZ &PNOBI +
                          &PWEIG &PORDN &PRT &D@P6)
             /** AB#C3R **********************************************/
             /*  ..EDI PICK-UP LIST..                                */
             /*                                                      */
             /* %0001 T.SAKAKI   ADD NEW COMMON LAYOUT      04/06/18 */
             /* %0002 T.SAKAKI   REMOVE  AB#R3C             06/27/18 */
             /* JW1   2022.05.16 ADD OPTION X AND Y                  */
             /* JW2   2023.02.27 CHG OPTION Y TO PDF                 */
             /* JW2   2025.03.13 CHG OPTION Y TO PDF                 */
             /* JW3   2025.12.19 ADD OPTION Y TO TRIAL PART (&D@P6)  */
             /*----------------------------------------------------- */
             /* &PTYPE  2A  PACKING LIST TYPE (01 - 10)              */
             /* &PPICK  2A  # OF COY                                 */
             /* &PSIRE  4A  DELIVERY CODE                            */
             /* &PNOHZ  8A  SHIP DATE                                */
             /* &PNOBI  2A  BIN#                                     */
             /* &PWEIG  3,2 WEIGHT                                   */
             /* &PORDN 10A  ORDER#                                   */
             /* &PRT    1A  PRINTER (1-9, X, Y)                      */
             /********************************************************/
             DCL        VAR(&PPICK)   TYPE(*DEC) LEN(2)
             DCL        VAR(&PTYPE)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PSIRE)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&PNOHZ)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PNOBI)   TYPE(*DEC) LEN(2)
             DCL        VAR(&PWEIG)   TYPE(*DEC) LEN(3 2)
             DCL        VAR(&PMANI)   TYPE(*CHAR) LEN(18)
             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PORDN)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&POUT)    TYPE(*CHAR) LEN(10)
 /*%0001*/   DCL        VAR(&ORGOUT)  TYPE(*CHAR) LEN(10)
 /*%0001*/   DCL        VAR(&PLTP)    TYPE(*CHAR) LEN(1) VALUE(' ')
 /*JW2*/     DCL        VAR(&XSPL)    TYPE(*CHAR) LEN(8) VALUE(' ')
 /*JW3*/     DCL        VAR(&D@P6)    TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER)

             IF  COND(&PRT *EQ '1') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT02))
             IF  COND(&PRT *EQ '2') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT07))
             IF  COND(&PRT *EQ '3') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT08))
             IF  COND(&PRT *EQ '4') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT03))
             IF  COND(&PRT *EQ '5') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT04))
             IF  COND(&PRT *EQ '6') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT09))
             IF  COND(&PRT *EQ '7') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT10))
             IF  COND(&PRT *EQ '8') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT05))
             IF  COND(&PRT *EQ '9') THEN(CHGVAR VAR(&POUT) VALUE(QDKT))
 /*JW1*/     IF  COND(&PRT *EQ 'X') THEN(CHGVAR VAR(&POUT) VALUE(QDKT))
             IF  COND(&PRT *EQ 'Y') THEN(CHGVAR VAR(&POUT) VALUE(EPRINT3))
             IF  COND(&PRT *EQ 'A') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT06))
             IF  COND(&PRT *EQ 'B') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT50))

 /* %0001 SAVE ORIGINAL OUTQ */
             CHGVAR VAR(&ORGOUT) VALUE(&POUT)

 /* CHECK LIST TYPE SWITCHING MASTER */
             CALL       PGM(AB#R9S) PARM(&PSIRE &PLTP)

    /* NOT PRINT IF ONLY NEW LAYOUT */
             IF         COND(&PLTP *EQ 'N') THEN(CHGVAR VAR(&POUT) +
                          VALUE(QDKT))


 /*=== PACKING LIST TYPE ="01" OR "07" ===*/
             IF         COND((&PTYPE *EQ '01') *OR +
                             (&PTYPE *EQ '07')) THEN(DO)
             IF         COND(&PSIRE *EQ '0492') THEN(DO)
                        CALL    PGM(AB#R95) +
                                PARM(&USER &PSIRE &PNOHZ &PNOBI &PMANI)
             ENDDO
             OVRPRTF    FILE(AB#PR3G) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK) +
                          EXPDATE(*DAYS) DAYS(14)
/********    CALL       PGM(AB#R3G) PARM(&PWEIG &PMANI)  ****/
/* JW3 */    CALL       PGM(AB#R3G) PARM(&PWEIG &PMANI &D@P6)
             ENDDO

 /*=== PACKING LIST TYPE ="02" OR "09" ===*/
             IF         COND(&PTYPE *EQ '02' *OR &PTYPE *EQ '09') +
                          THEN(DO)

     /* GET THE MANIFEST NUMBER */
             CALL       PGM(AB#R95) PARM(&USER &PSIRE &PNOHZ &PNOBI +
                          &PMANI)
             IF         COND(&PSIRE *EQ '0235'  +
                         *OR &PSIRE *EQ '0271'  +
                         *OR &PSIRE *EQ '0275'  +
                         *OR &PSIRE *EQ '0276') THEN(DO)
             OVRPRTF    FILE(AB#PR3AB) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK) +
                          EXPDATE(*DAYS) DAYS(14)

/********       CALL PGM(AB#R3A2) PARM(&PWEIG &PMANI &PORDN)  ****/
/* JW3 */       CALL PGM(AB#R3A2) PARM(&PWEIG &PMANI &PORDN &D@P6)

             ENDDO
             ELSE DO
             OVRPRTF    FILE(AB#PR3A) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK) +
                          EXPDATE(*DAYS) DAYS(14)
             IF         COND(&PSIRE *EQ '3656'  +
                         *OR &PSIRE *EQ '3682'  +
                         *OR &PSIRE *EQ '3712'  +
                         *OR &PSIRE *EQ '3713'  +
                         *OR &PSIRE *EQ '3824'  +
                         *OR &PSIRE *EQ '3842') THEN(DO)

/********       CALL PGM(AB#R3A1) PARM(&PWEIG &PMANI &PORDN)  ****/
/* JW3 */       CALL PGM(AB#R3A1) PARM(&PWEIG &PMANI &PORDN &D@P6)

             ENDDO
             ELSE DO

/********       CALL PGM(AB#R3A) PARM(&PWEIG &PMANI &PORDN)   ****/
/* JW3 */       CALL PGM(AB#R3A) PARM(&PWEIG &PMANI &PORDN &D@P6)

             ENDDO
             ENDDO
             ENDDO

 /*=== PACKING LIST TYPE ="03" ===*/
             IF         COND(&PTYPE *EQ '03') THEN(DO)
             OVRPRTF    FILE(AB#PR3C) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK) +
                          EXPDATE(*DAYS) DAYS(14)

             OVRPRTF    FILE(AB#PR3D) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK) +
                          EXPDATE(*DAYS) DAYS(14)

             OVRPRTF    FILE(AB#PR3E) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK) +
                          EXPDATE(*DAYS) DAYS(14)
             OVRPRTF    FILE(AB#PR3F) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK) +
                          EXPDATE(*DAYS) DAYS(14)

       /** %0002 **/
/********    CALL       PGM(AB#R3M) PARM(&PWEIG &PTYPE)  ****/
/* JW3 */    CALL       PGM(AB#R3M) PARM(&PWEIG &PTYPE &D@P6)

             ENDDO


 /*=== PACKING LIST TYPE ="04", "05 OR "06" ===*/
             IF         COND(&PTYPE *GE '04' *AND &PTYPE *LE '06') +
                          THEN(DO)

             OVRPRTF    FILE(AB#PR3C) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK) +
                          EXPDATE(*DAYS) DAYS(14)

             OVRPRTF    FILE(AB#PR3D) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK) +
                          EXPDATE(*DAYS) DAYS(14)

             OVRPRTF    FILE(AB#PR3E) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK) +
                          EXPDATE(*DAYS) DAYS(14)

             OVRPRTF    FILE(AB#PR3F) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK) +
                          EXPDATE(*DAYS) DAYS(14)

/********    CALL       PGM(AB#R3D) PARM(&PWEIG &PTYPE)  ****/
/* JW3 */    CALL       PGM(AB#R3D) PARM(&PWEIG &PTYPE &D@P6)

             ENDDO


 /*=== PACKING LIST TYPE ="08" ===*/
             IF         COND(&PTYPE *EQ '08') THEN(DO)
             OVRPRTF    FILE(AB#PR3J) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK) +
                          EXPDATE(*DAYS) DAYS(14)

 /********   CALL       PGM(AB#R3J) PARM(&PWEIG)  ****/
 /* JW3 */   CALL       PGM(AB#R3J) PARM(&PWEIG &D@P6)

             ENDDO


 /*=== PACKING LIST TYPE ="10" ===*/
             IF         COND(&PTYPE *EQ '10') THEN(DO)
             CALL       PGM(AB#R95) PARM(&USER &PSIRE &PNOHZ &PNOBI &PMANI)
             OVRPRTF    FILE(AB#PR3R) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK) +
                          EXPDATE(*DAYS) DAYS(14)
             IF         COND(&PSIRE *EQ '3656'  +
                         *OR &PSIRE *EQ '3682'  +
                         *OR &PSIRE *EQ '3712'  +
                         *OR &PSIRE *EQ '3713'  +
                         *OR &PSIRE *EQ '3824'  +
                         *OR &PSIRE *EQ '3842') THEN(DO)

 /********   CALL       PGM(AB#R3R1) PARM(&PWEIG &PMANI &PORDN)  ****/
 /* JW3 */   CALL       PGM(AB#R3R1) PARM(&PWEIG &PMANI &PORDN &D@P6)

             ENDDO
             ELSE DO

 /********   CALL       PGM(AB#R3R) PARM(&PWEIG &PMANI &PORDN)   ****/
 /* JW3 */   CALL       PGM(AB#R3R) PARM(&PWEIG &PMANI &PORDN &D@P6)

             ENDDO
             ENDDO

    /* NOT PRINT IF ONLY OLD LAYOUT */
             IF         COND(&PLTP *EQ 'O') THEN(GOTO CMDLBL(END))

    /* NEW PACKING LIST */
             CHGVAR     VAR(&POUT) VALUE(&ORGOUT)
             IF         COND(&POUT *NE 'LANPRT02') THEN(DO)
             OVRPRTF    FILE(AB#PR3K) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK) +
                          EXPDATE(*DAYS) DAYS(14)
             ENDDO

    /* **  if lanprt02, then make it pull from drawer 2...   ** */
             IF         COND(&POUT *EQ 'LANPRT02') THEN(DO)
             OVRPRTF    FILE(AB#PR3K) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&POUT) FORMTYPE(K6S1) COPIES(&PPICK) +
                          EXPDATE(*DAYS) DAYS(14) DRAWER(2)
             ENDDO

    /* JW2 IF &PRT=Y, DOWNLOAD TO PDF                            */
    /***   IF         COND(&PRT *EQ 'Y') THEN(DO)                           ***/
    /***   IF  COND(&PTYPE *EQ '01') THEN(CHGVAR VAR(&XSPL) VALUE(AB#PR3G)) ***/
    /***   IF  COND(&PTYPE *EQ '02') THEN(CHGVAR VAR(&XSPL) VALUE(AB#PR3A)) ***/
    /***   IF  COND(&PTYPE *EQ '03') THEN(CHGVAR VAR(&XSPL) VALUE(AB#PR3C)) ***/
    /***   IF  COND(&PTYPE *EQ '04') THEN(CHGVAR VAR(&XSPL) VALUE(AB#PR3D)) ***/
    /***   IF  COND(&PTYPE *EQ '05') THEN(CHGVAR VAR(&XSPL) VALUE(AB#PR3E)) ***/
    /***   IF  COND(&PTYPE *EQ '06') THEN(CHGVAR VAR(&XSPL) VALUE(AB#PR3F)) ***/
    /***   IF  COND(&PTYPE *EQ '07') THEN(CHGVAR VAR(&XSPL) VALUE(AB#PR3G)) ***/
    /***   IF  COND(&PTYPE *EQ '08') THEN(CHGVAR VAR(&XSPL) VALUE(AB#PR3J)) ***/
    /***   IF  COND(&PTYPE *EQ '09') THEN(CHGVAR VAR(&XSPL) VALUE(AB#PR3A)) ***/
    /***   IF  COND(&PTYPE *EQ '10') THEN(CHGVAR VAR(&XSPL) VALUE(AB#PR3R)) ***/
    /***   CALL       PGM(SPLC10) PARM(&PSIRE &XSPL 'N')                    ***/
    /***   ENDDO                                                            ***/

             CALL       PGM(AB#R30)

    /* JW2 IF &PRT=Y, DOWNLOAD TO PDF                            */
             IF         COND(&PRT *EQ 'Y') THEN(DO)
             CHGVAR     VAR(&XSPL) VALUE(AB#PR3K)
             CALL       PGM(SPLC10) PARM(&PSIRE &XSPL 'N')
             ENDDO

 /* SAVE AB#WP37 */
              CALL       PGM(EDSR03)
 END:
             IF         COND((&USER *NE 'I0777') *AND (&USER *NE +
                          'TEST ')) THEN(DO)
             CLRPFM     FILE(QTEMP/AB#WP37)
             MONMSG     MSGID(CPF3142)
             ENDDO

             ENDPGM
