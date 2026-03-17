             PGM
             /** FCEC38 *******************************************/
             /* PLATING HANDLING CODE M/F                   CL    */
             /*         A-SENGA           1981.11.09              */
             /*                                                   */
             /* TCHK1 10/13/06 CHG OUTQ CONTROL                   */
             /******************************************* FCEC38 **/
             DCLF       FILE(FCEPW04)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID)

   /*        CALL       PGM(KZZR00) PARM(&WSID &PRT &TYPE &PRTG)    */
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CHGVAR     VAR(&YOSI) VALUE('K6H1')
             CHGVAR     VAR(&BSU)  VALUE('1')
/* TCHK1 */  CHGVAR     VAR(&D@PRT) VALUE('4')

STEP1:       SNDRCVF  DEV(&WSID) RCDFMT(FCEPW041)
             IF         (&IN01 = '1') RETURN

             IF         (&YOSI = 'K6H1') GOTO STEP2
             IF         (&YOSI = 'K6H2') GOTO STEP2
             IF         (&YOSI = 'K6H3') GOTO STEP2
             GOTO       STEP1

 STEP2:      IF         (&BSU < 1) GOTO STEP1

/* TCHK1 STRART */
             IF         COND(&D@PRT *EQ '1') THEN(CHGVAR VAR(&PRTG) +
                          VALUE(LANPRT02))
             IF         COND(&D@PRT *EQ '2') THEN(CHGVAR VAR(&PRTG) +
                          VALUE(LANPRT07))
             IF         COND(&D@PRT *EQ '3') THEN(CHGVAR VAR(&PRTG) +
                          VALUE(LANPRT08))
             IF         COND(&D@PRT *EQ '4') THEN(CHGVAR VAR(&PRTG) +
                          VALUE(LANPRT03))
             IF         COND(&D@PRT *EQ '5') THEN(CHGVAR VAR(&PRTG) +
                          VALUE(QPRINTA))
             IF         COND(&D@PRT *EQ '6') THEN(CHGVAR VAR(&PRTG) +
                          VALUE(LANPRT09))
             IF         COND(&D@PRT *EQ '7') THEN(CHGVAR VAR(&PRTG) +
                          VALUE(LANPRT10))
             IF         COND(&D@PRT *EQ '8') THEN(CHGVAR VAR(&PRTG) +
                          VALUE(LANPRT05))
             IF         COND(&D@PRT *EQ '9') THEN(CHGVAR VAR(&PRTG) +
                          VALUE(QDKT))
/* TCHK1 END */
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(&YOSI) COPIES(&BSU) IGCDTA(&PIGCD)
             CALL       PGM(FCER38)
             DLTOVR     FILE(QPRINT)

             ENDPGM
