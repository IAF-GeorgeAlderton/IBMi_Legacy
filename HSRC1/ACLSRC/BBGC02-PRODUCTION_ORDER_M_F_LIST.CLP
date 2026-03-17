             PGM
             /*** BBGC02 ***************************/
             /* PRODUCTION ORDER M/F LIST        */
             /* G.B.C 90.04.19                     */
             /************************* BBGC02 *****/
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSNO)

             CALL       PGM(KZZR00) PARM(&WSNO &PRT &TYPE &PRTG)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6S1)

             CALL       PGM(BBGR02)
             DLTOVR     FILE(QPRINT)

             ENDPGM
