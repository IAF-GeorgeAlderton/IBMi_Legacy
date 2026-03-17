             PGM        PARM(&SIRE &MIX &PRT)
             /** AB#C48   *********************************************/
             /*  MIXED PALLET LIST                                    */
             /*---------------------------------------                */
             /* JW1   2023.05.25 ADD PDF OUTPUT                       */
             /*********************************************************/

             DCL        VAR(&SIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MIX)  TYPE(*DEC)  LEN(3 0)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&POUT) TYPE(*CHAR) LEN(10)
/*JW*        DCL        VAR(&NONY) TYPE(*CHAR) LEN(4)    ***/

             IF   COND(&PRT *EQ '1') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT02))
             IF   COND(&PRT *EQ '2') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT07))
             IF   COND(&PRT *EQ '3') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT08))
             IF   COND(&PRT *EQ '4') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT03))
             IF   COND(&PRT *EQ '5') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT04))
             IF   COND(&PRT *EQ '6') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT09))
             IF   COND(&PRT *EQ '7') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT10))
             IF   COND(&PRT *EQ '8') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT05))
             IF   COND(&PRT *EQ '9') THEN(CHGVAR VAR(&POUT) VALUE(QDKT))
/*JW1*/      IF   COND(&PRT *EQ 'X') THEN(CHGVAR VAR(&POUT) VALUE(QDKT))
             IF   COND(&PRT *EQ 'Y') THEN(CHGVAR VAR(&POUT) VALUE(EPRINT3))
             IF   COND(&PRT *EQ 'A') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT06))
             IF   COND(&PRT *EQ 'B') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT50))


         /*  OVRPRTF    FILE(AB#PR44) PAGESIZE(66 80) LPI(6) +    */
         /*               RPLUNPRT(*YES) OUTQ(&POUT) +            */
         /*               FORMTYPE(K6S1) COPIES(1)                */

             IF         COND(&POUT *NE 'LANPRT02') THEN(DO)
             OVRPRTF    FILE(AB#PR45) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&POUT) +
                          FORMTYPE(K6S1) COPIES(1)
             ENDDO

     /* **  if lanprt02, then make it pull from drawer 2...   ** */
             IF         COND(&POUT *EQ 'LANPRT02') THEN(DO)
             OVRPRTF    FILE(AB#PR45) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&POUT) +
                          FORMTYPE(K6S1) COPIES(1) DRAWER(2)
             ENDDO


    /**JW    CALL       PGM(AB#R48) PARM(&MIX)       *****/
             CALL       PGM(AB#R48) PARM(&MIX &SIRE)

/* DOWNLOAD TO PDF */
             IF         COND(&PRT *EQ 'Y') THEN(DO)
             CALL       PGM(SPLC12) PARM(&SIRE 'AB#PR45 ' 'N')
             ENDDO

             ENDPGM
