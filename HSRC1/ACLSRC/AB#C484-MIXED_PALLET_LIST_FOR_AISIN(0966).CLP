             PGM        PARM(&SIRE &MIX &PRT)
             /** AB#C484  *********************************************/
             /*  MIXED PALLET LIST FOR AISIN(0966)                    */
             /*---------------------------------------                */
             /* TCHK1 05/26/10 CREATE(COPY FROM AB#C48)               */
             /* JW1   2023.05.25 ADD PDF OUTPUT                       */
             /*********************************************************/

             DCL        VAR(&SIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MIX)  TYPE(*DEC)  LEN(3 0)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&POUT) TYPE(*CHAR) LEN(10)

             IF    COND(&PRT *EQ '1') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT02))
             IF    COND(&PRT *EQ '2') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT07))
             IF    COND(&PRT *EQ '3') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT08))
             IF    COND(&PRT *EQ '4') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT03))
             IF    COND(&PRT *EQ '5') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT04))
             IF    COND(&PRT *EQ '6') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT09))
             IF    COND(&PRT *EQ '7') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT10))
             IF    COND(&PRT *EQ '8') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT05))
             IF    COND(&PRT *EQ '9') THEN(CHGVAR VAR(&POUT) VALUE(QDKT    ))
 /*JW*/      IF    COND(&PRT *EQ 'X') THEN(CHGVAR VAR(&POUT) VALUE(QDKT    ))
             IF    COND(&PRT *EQ 'Y') THEN(CHGVAR VAR(&POUT) VALUE(EPRINT3 ))
             IF    COND(&PRT *EQ 'A') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT06))
             IF    COND(&PRT *EQ 'B') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT50))


             IF         COND(&POUT *NE 'LANPRT02') THEN(DO)
             OVRPRTF    FILE(AB#PR44) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&POUT) +
                          FORMTYPE(K6S1) COPIES(1)
             ENDDO

   /* **  if lanprt02, then make it pull from drawer 2...   ** */
             IF         COND(&POUT *EQ 'LANPRT02') THEN(DO)
             OVRPRTF    FILE(AB#PR44) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&POUT) +
                          FORMTYPE(K6S1) COPIES(1) DRAWER(2)
             ENDDO

             CALL       PGM(AB#R484) PARM(&MIX)

/* DOWNLOAD TO PDF */
             IF         COND(&PRT *EQ 'Y') THEN(DO)
             CALL       PGM(SPLC12) PARM(&SIRE 'AB#PR44 ' 'N')
             ENDDO

             ENDPGM
