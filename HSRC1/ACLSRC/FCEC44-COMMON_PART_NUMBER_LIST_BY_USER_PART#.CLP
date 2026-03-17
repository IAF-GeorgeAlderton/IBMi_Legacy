             PGM
             /***FCEC44********************************************/
             /* COMMON PART NUMBER LIST ..USER PART NUMBERTEN DAYS . OP-EDP */
             /*         A-SENGA           1982.01.28    CL MAIN */
             /*****************************************************/
             DCLF       FILE(FCEPW04) RCDFMT(FCEPW041)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&OUTQ ) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CHGVAR     VAR(&YOSI) VALUE('K6H1')
             CHGVAR     VAR(&BSU)  VALUE('1')
/*JW*/       CHGVAR     VAR(&IN40) VALUE('1')

STEP1:       SNDRCVF  DEV(&WSID) RCDFMT(FCEPW041)
             IF         (&IN01 = '1') RETURN

             CHGVAR     VAR(&IN41) VALUE('0')
             CHGVAR     VAR(&IN42) VALUE('0')
             CHGVAR     VAR(&IN43) VALUE('0')

             IF         (&YOSI = 'K6H1') GOTO STEP2
             IF         (&YOSI = 'K6H2') GOTO STEP2
             IF         (&YOSI = 'K6H3') GOTO STEP2
             CHGVAR     VAR(&XMSG) VALUE('PAPER TYPE ERROR!')
             CHGVAR     VAR(&IN41) VALUE('1')
             GOTO       STEP1

 STEP2:      IF         COND(&BSU < 1) THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('ENTER # OF COPIES!')
             CHGVAR     VAR(&IN42) VALUE('1')
             GOTO       STEP1
             ENDDO

 STEP3:      IF         COND((&D@PRT *NE '1') *AND (&D@PRT *NE '2') +
                        *AND (&D@PRT *NE '3') *AND (&D@PRT *NE '4') +
                        *AND (&D@PRT *NE '5') *AND (&D@PRT *NE '6') +
                        *AND (&D@PRT *NE '7') *AND (&D@PRT *NE '8') +
                        *AND (&D@PRT *NE '9') *AND (&D@PRT *NE 'X')) THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('ENTER # OF COPIES!')
             CHGVAR     VAR(&IN43) VALUE('1')
             GOTO   STEP1
             ENDDO

 /** NO ERROR **/
             IF  COND(&D@PRT *EQ '1') THEN(CHGVAR VAR(&OUTQ) VALUE(LANPRT02))
             IF  COND(&D@PRT *EQ '2') THEN(CHGVAR VAR(&OUTQ) VALUE(LANPRT07))
             IF  COND(&D@PRT *EQ '3') THEN(CHGVAR VAR(&OUTQ) VALUE(LANPRT08))
             IF  COND(&D@PRT *EQ '4') THEN(CHGVAR VAR(&OUTQ) VALUE(LANPRT03))
             IF  COND(&D@PRT *EQ '5') THEN(CHGVAR VAR(&OUTQ) VALUE(LANPRT04))
             IF  COND(&D@PRT *EQ '6') THEN(CHGVAR VAR(&OUTQ) VALUE(LANPRT09))
             IF  COND(&D@PRT *EQ '7') THEN(CHGVAR VAR(&OUTQ) VALUE(LANPRT10))
             IF  COND(&D@PRT *EQ '8') THEN(CHGVAR VAR(&OUTQ) VALUE(LANPRT05))
             IF  COND(&D@PRT *EQ '9') THEN(CHGVAR VAR(&OUTQ) VALUE(QDKT    ))

             CHGVAR     VAR(&OUTQ) VALUE('QDKT  ')

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&OUTQ) FORMTYPE(&YOSI) COPIES(&BSU) +
                          FILESEP(0) IGCDTA(&PIGCD)
             CALL       PGM(FCER44)

             DLTOVR     FILE(QPRINT)

             ENDPGM
