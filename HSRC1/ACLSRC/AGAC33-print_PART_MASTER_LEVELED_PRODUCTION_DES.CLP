             PGM
             /*** AGAR33 ********************************************/
             /*PRINT PART MASTER/LEVELED PRODUCTION DISCREPANCY   */
             /*       M...        91.06.18                          */
             /*******************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSNO) USER(&USER)
             CHGJOB     RUNPTY(40)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1)

             CALL       PGM(AGAR33)
             DLTOVR     FILE(QPRINT)

             CHGJOB     RUNPTY(20)

             ENDPGM
