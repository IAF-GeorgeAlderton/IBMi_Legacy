             PGM
             /**FCKC11********************************/
             /* ARRIVAL M/F BY  SUPPLIER  ... CL */
             /* I-HASADA                82.11.19     */
             /********************************FCKC11**/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&HIY1) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&HIY2) TYPE(*CHAR) LEN(1) VALUE('0')
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7) VALUE('QPRINT ')
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSID) USER(&US)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRT) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(FCKR11) PARM(&US &HIY1 &HIY2)
             DLTOVR     FILE(QPRINT)

             ENDPGM
