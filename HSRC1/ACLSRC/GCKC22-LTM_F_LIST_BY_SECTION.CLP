             PGM
             /** GCKC22 ****************************/
             /* LTM/F LIST BY SECTION... */
             /* I-HASADA              85.12.16     */
             /**************************** GCKC22 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             OVRPRTF    FILE(GCKPR22) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(64) RPLUNPRT(*YES) +
                          SPOOL(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          SCHEDULE(*FILEEND) IGCDTA(&PIGCD)
             CALL       PGM(GCKR22)
             DLTOVR     FILE(GCKPR22)

             ENDPGM
