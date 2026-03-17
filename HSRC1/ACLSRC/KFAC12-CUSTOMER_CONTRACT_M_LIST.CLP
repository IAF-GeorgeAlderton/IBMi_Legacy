             PGM
             /** KFAC12 ********************************************/
             /* CUSTOMER CONTRACT M/LIST                           */
             /*            S.YAMAGAMI      1997.03.20              */
             /******************************************************/
             DCL        VAR(&US)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             RTVJOBA    JOB(&WSID)  USER(&US)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

             OVRPRTF    FILE(QPRINT) PAGESIZE(66 198) LPI(6) CPI(15) +
                          OVRFLW(60) RPLUNPRT(*YES) OUTQ(QPRINT) +
                          FORMTYPE(K6H1)

             CALL       PGM(KFAR12) PARM(&US)
             ENDPGM
