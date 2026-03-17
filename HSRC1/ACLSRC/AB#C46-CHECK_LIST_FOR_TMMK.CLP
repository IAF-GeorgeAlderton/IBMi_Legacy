             PGM        PARM(&PRT)
             /** AB#C46 **********************************************/
             /*  ..TMMK CHECK LIST                                   */
             /*                                                      */
             /* TCHK1 12/26/05 CHG PRINTER CONTROL                   */
             /* TCHK2 01/12/07 CHG PRINTER CONTROL                   */
             /* JW1   2022.05.16 ADD OPTION X AND Y                  */
             /********************************************** AB#C46 **/
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&POUT)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NONY)  TYPE(*CHAR) LEN(4)

             IF  COND(&PRT *EQ '1') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT02))
             IF  COND(&PRT *EQ '2') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT07))
             IF  COND(&PRT *EQ '3') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT08))
             IF  COND(&PRT *EQ '4') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT03))
             IF  COND(&PRT *EQ '5') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT04))
/* TCHK1 */  IF  COND(&PRT *EQ '6') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT09))
/* TCHK1 */  IF  COND(&PRT *EQ '7') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT10))
/* TCHK1 */  IF  COND(&PRT *EQ '8') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT05))
/* TCHK1 */  IF  COND(&PRT *EQ '9') THEN(CHGVAR VAR(&POUT) VALUE(QDKT))
/* JW1   */  IF  COND(&PRT *EQ 'X') THEN(CHGVAR VAR(&POUT) VALUE(QDKT))
             IF  COND(&PRT *EQ 'Y') THEN(CHGVAR VAR(&POUT) VALUE(EPRINT3))
             IF  COND(&PRT *EQ 'A') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT06))
             IF  COND(&PRT *EQ 'B') THEN(CHGVAR VAR(&POUT) VALUE(LANPRT50))


             OVRPRTF    FILE(QPRINT) PAGESIZE(66 80) LPI(6) +
                          OVRFLW(60) RPLUNPRT(*YES) OUTQ(&POUT) +
                          FORMTYPE(K6S1)
     /***JW  CALL       PGM(AB#R46)      *****/
             CALL       PGM(AB#R46) PARM(&NONY)

 /* OUT PDF */
             IF         COND(&PRT *EQ 'Y') THEN(DO)
             CALL       PGM(SPLC16) PARM(&NONY 'QPRINT' 'N')
             ENDDO

             DLTOVR     FILE(QPRINT)

             ENDPGM
