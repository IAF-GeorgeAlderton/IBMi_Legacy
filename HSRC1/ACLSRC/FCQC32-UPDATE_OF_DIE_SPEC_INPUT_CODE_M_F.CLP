             PGM
             /** FCQC32 ******************************************/
             /*     ...UPDATE OF DIE SPEC INPUT CODE M/F */
             /*         I-HASADA                85.03.15         */
             /****************************************** FCQC32 **/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WS) USER(&US)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYP &PRTG)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) OUTQ(&PRT) +
                          FORMTYPE(K6H1)
             CALL       PGM(FCQR32) PARM(&US)
             DLTOVR     FILE(QPRINT)

             ENDPGM
