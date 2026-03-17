             PGM
             /** FCQC31 *********************************/
             /*     ...UPDATE OF DIE M/F    ...     */
             /*         I-HASADA       85.03.15         */
             /********************************* FCQC31 **/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WS) USER(&US)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) OUTQ(&PRT) +
                          FORMTYPE(K6H1)
             CALL       PGM(FCQR31) PARM(&US)
             DLTOVR     FILE(QPRINT)
             ENDPGM
