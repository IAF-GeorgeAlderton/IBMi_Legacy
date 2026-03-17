             PGM
             /***FCEC42********************************************/
             /* COMMON PART NUMBER LIST ..INTRAL COMPANY PART NUMBER */
             /* TEN DAYS.. OP-EDP */
             /*         A-SENGA           1981.10.09    CL MAIN */
             /*****************************************************/
             DCLF       FILE(FCEPW04) RCDFMT(FCEPW041)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CHGVAR     VAR(&YOSI) VALUE('K6H1')
             CHGVAR     VAR(&BSU) VALUE('1')
/*JW*/       CHGVAR     VAR(&IN41) VALUE('1')

STEP1:       SNDRCVF  DEV(&WSID) RCDFMT(FCEPW041)
             IF         (&IN01 = '1') RETURN
             IF         (&YOSI = 'K6H1') GOTO STEP2
             IF         (&YOSI = 'K6H2') GOTO STEP2
             IF         (&YOSI = 'K6H3') GOTO STEP2
             GOTO       STEP1

 STEP2:      IF         (&BSU < 1) GOTO STEP1
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          FORMTYPE(&YOSI) COPIES(&BSU) FILESEP(0) +
                          IGCDTA(&PIGCD)
             CALL       PGM(FCER42)
             DLTOVR     FILE(QPRINT)

             ENDPGM
