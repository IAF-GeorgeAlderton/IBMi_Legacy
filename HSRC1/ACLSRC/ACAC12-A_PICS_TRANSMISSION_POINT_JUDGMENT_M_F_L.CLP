             PGM
             /*** ACAC12 **************************************/
             /*  A-PICSTRANSMISSION POINT JUDGMENT M/F LIST */
             /*       G.B.C       88.06.08                    */
             /************************* ACAC12 ****************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSNO) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSNO &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6S1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(ACAR12)
             DLTOVR     FILE(QPRINT)

             ENDPGM
