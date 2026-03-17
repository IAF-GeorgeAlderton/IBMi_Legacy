             PGM
             /***FCEC17********************************************/
             /*        PARTS NAME MASTER LIST   CL xb]   OP-EDP   */
             /*            M-OKUDA        1981.10.09              */
             /*****************************************************/
             DCLF       FILE(FCEPW03) RCDFMT(FCEPW031)
             DCL      VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL      VAR(&PRT) TYPE(*CHAR) LEN(7) VALUE(QPRINT)
             RTVJOBA  JOB(&WSID)
             CALL       PGM(DGAR00) PARM(&WSID &PRT)
             CHGVAR     VAR(&YOSI) VALUE('K6S1')
             CHGVAR     VAR(&BSU) VALUE('1')
STEP1:       SNDRCVF  DEV(&WSID) RCDFMT(FCEPW031)
             IF         (&IN01 = '1') RETURN
             IF         (&YOSI = 'K6S1') GOTO STEP2
             IF         (&YOSI = 'K6H1') GOTO STEP2
             GOTO       STEP1
 STEP2:      IF         (&BSU < 1) GOTO STEP1
             OVRPRTF    FILE(QPRINT) TOFILE(*FILE) PAGESIZE(66 80) +
                          LPI(6) OVRFLW(60) RPLUNPRT(*YES) OUTQ(&PRT) +
                          FORMTYPE(&YOSI) COPIES(&BSU) FILESEP(0)
             CALL       PGM(FCER17)
             DLTOVR     FILE(QPRINT)
             ENDPGM
