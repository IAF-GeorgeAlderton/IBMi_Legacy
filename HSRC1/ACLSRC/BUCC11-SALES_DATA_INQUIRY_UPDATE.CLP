             PGM
             /** BUCC11 **********************************/
             /* SALES DATA INQUIRY / UPDATE              */
             /* I-HASADA 81.11.07 N.HAYAKAWA             */
             /*                                          */
             /* TCHK1 01/25/09 CHG OUTQ(QDKT)            */
             /********************************** BUCC11 **/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID) USER(&US)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)

/* TCHK1    OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          OVRFLW(64) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD) */
/* TCHK1 */ OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          OVRFLW(64) RPLUNPRT(*YES) OUTQ(QDKT) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(BUCR11) PARM(&US &WSID)
             DLTOVR     FILE(QPRINT)

             ENDPGM
