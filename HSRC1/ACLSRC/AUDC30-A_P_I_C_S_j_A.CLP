             PGM
             /*** AUDC30 *********************************/
             /*     Ａ－ＰＩＣＳ繁栄データ　時間別     */
             /********************************* AUDC30 ***/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSID)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

/*           OVRPRTF    FILE(QPRINT) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(APOUTQ) FORMTYPE(K6H1) HOLD(*YES) +
                          IGCSOSI(*YES)  */
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) OVRFLW(60) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          HOLD(*YES) IGCDTA(&PIGCD)
             CALL       PGM(AUDR30)
             DLTOVR     FILE(QPRINT)

             ENDPGM
