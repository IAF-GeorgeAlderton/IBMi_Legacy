             PGM
             /***FCEC18********************************************/
             /* MATERIAL PROD.    ORDER M/F LIST CL MAIN OP-EDP */
             /*            A-SENGA        1981.10.13              */
             /*****************************************************/
             DCLF       FILE(FCEPW04) RCDFMT(FCEPW041)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7) VALUE(QPRINT)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CHGVAR     VAR(&YOSI) VALUE('K6H1')
             CHGVAR     VAR(&BSU)  VALUE('1')

 STEP1:      SNDRCVF    DEV(&WSID) RCDFMT(FCEPW041)

             IF         (&IN01 = '1') RETURN

             IF         COND((&YOSI *NE 'K6H1') *AND (&YOSI *NE +
                          'K6H2') *AND (&YOSI *NE 'KH63')) +
                          THEN(GOTO CMDLBL(STEP1))
             IF         (&BSU < 1) GOTO STEP1

             OVRPRTF    FILE(QPRINT) TOFILE(*FILE) DEVTYPE(&PDEVT) +
                          PAGESIZE(66 132) LPI(6) OVRFLW(60) +
                          RPLUNPRT(*YES) OUTQ(&PRT) FORMTYPE(&YOSI) +
                          COPIES(&BSU) FILESEP(0) IGCDTA(&PIGCD)
             CALL       PGM(FCER18)
             DLTOVR     FILE(QPRINT)

             ENDPGM
