             PGM
             /** GCEC04 *********************************/
             /* PROCESS NAME M/F LIST < KANJI > */
             /*          M-OKUDA 1985.11.14             */
             /*******************************************/
             DCLF       FILE(GCEPW04)
             DCL        VAR(&US)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSID) USER(&US)

             CALL       AGAR01 PARM(&WSID &PDEVT &PIGCD)
             CALL       AGAR00 PARM(&WSID &PRT &TYPE &PRTG)

 STEP1:      SNDRCVF    RCDFMT(GCEPW041)

             IF         (&IN01 *EQ '1') GOTO END
             IF         (&IN05 *NE '1') GOTO STEP1

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(GCER04)
             DLTOVR     FILE(QPRINT)
             CHGJOB     OUTQ(&PRT)

 END:        ENDPGM
