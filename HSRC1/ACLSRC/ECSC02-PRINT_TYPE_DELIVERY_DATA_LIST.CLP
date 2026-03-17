             PGM
             /** ECSC02 **************************/
             /* ..THE TYPE DELIVERY DATA LIST .. */
             /*     A.MAMIYA        98.10.16     */
             /************************** ECSC02 **/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WS) USER(&US)

             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) CPI(15) OVRFLW(62) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
 /*  AS400 NO.3 TEST */
 /*          OVRPRTF    FILE(QPRINT) DEVTYPE(*SCS) PAGESIZE(66 132) +
                          LPI(6) CPI(15) OVRFLW(62) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) HOLD(*YES)  */

             CALL       PGM(ECSR02) PARM(&US)

             DLTOVR     FILE(*ALL)

             ENDPGM
