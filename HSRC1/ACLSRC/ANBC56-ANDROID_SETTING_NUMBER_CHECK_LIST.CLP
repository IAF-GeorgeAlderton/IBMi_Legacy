  PGM
/** ANBC56 ************************************************/
/*  ANDROID SETTING NUMBER CHECK LIST                     */
/*                                                        */
/* TCHK1 08/01/06 CREATE(COPY FROM ABBC56)                */
/**********************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSID) USER(&US)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)


             OVRPRTF    FILE(QPRINT) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1)
             CALL       PGM(ANBR56)
             DLTOVR     FILE(QPRINT)


             ENDPGM
