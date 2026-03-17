             PGM
             /** GCMC32 ****************************/
             /* ...KANBAN KIND M/F LIST ... */
             /* I-HASADA              85.12.14     */
             /**************************** GCMC32 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
 STP1:
             OVRPRTF    FILE(GCMPR32) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(64) RPLUNPRT(*YES) +
                          SPOOL(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          SCHEDULE(*FILEEND) IGCDTA(&PIGCD)
             CALL       PGM(GCMR32)
             DLTOVR     FILE(GCMPR32)
 END:        ENDPGM
