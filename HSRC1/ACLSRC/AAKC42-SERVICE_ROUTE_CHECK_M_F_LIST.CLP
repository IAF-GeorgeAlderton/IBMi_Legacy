             PGM
             /** AAKC42 **********************************/
             /*  SERVICE ROUTE CHECK M/F LIST */
             /*                A.IDOTA 1987.11.26 */
             /********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRT)
             OVRPRTF    FILE(AAKPR41) DEVTYPE(*AFPDS) LPI(6) +
                          OVRFLW(62) RPLUNPRT(*YES) OUTQ(QPRINTB) +
                          FORMTYPE(K6H1)
             CALL       PGM(AAKR42)
             DLTOVR     FILE(AAKPR41)
 END:        ENDPGM
