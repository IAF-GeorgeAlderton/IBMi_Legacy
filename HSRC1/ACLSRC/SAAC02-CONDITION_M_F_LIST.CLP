             PGM
             /*** SAAC02 *****************************/
             /*        CONDITION M/F LIST          */
             /* H.ITO               86.06.02         */
             /***************************** SAAC02 ***/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             CALL       PGM(AGAR00) PARM(&JOB &PRT &TYPE &PRTG)
             OVRPRTF    FILE(QPRINT) DEVTYPE(*SCS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(HASAYAN) +
                          FORMTYPE(K6H1) IGCDTA(*NO)
             CALL       PGM(AAAR02)
             DLTOVR     FILE(QPRINT)
             ENDPGM
