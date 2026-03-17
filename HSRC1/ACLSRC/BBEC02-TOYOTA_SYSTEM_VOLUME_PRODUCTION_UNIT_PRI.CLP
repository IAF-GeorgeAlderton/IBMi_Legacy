             PGM
             /*** BBEC02 ***************************/
             /*TOYOTA SYSTEM VOLUME PRODUCTION UNIT PRICE */
             /*             JUDGMENT USER M/F LIST */
             /* G.B.C 90.04.13                     */
             /************************* BBEC02 *****/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSNO) USER(&USER)

             CALL       PGM(KZZR00) PARM(&WSNO &PRT &TYPE &PRTG)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6S1)

             CALL       PGM(BBER02)
             DLTOVR     FILE(QPRINT)

             ENDPGM
