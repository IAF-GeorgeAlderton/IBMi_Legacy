             PGM
             /**** GDIC40 **********************/
             /*  INPUT OF ARRIVAL INFORMATION  */
             /*   N.HAYAKAWA        97/02/24   */
             /**********************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)
             OVRPRTF    FILE(QPRINT) OVRFLW(51) OUTQ(&PRTG) +
                          FORMTYPE(K6H1)
             CALL       PGM(GDIR40) PARM(&USER)
             DLTOVR     FILE(*ALL)

             ENDPGM
