             PGM
             /*** AJBC20 ****************/
             /* PASSWORD MANAGEMENT ACCOUNT BOOK */
             /* H.ITO 87.05.20 */
             /**************** AJBC20 ***/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) RPLUNPRT(*YES ' ') +
                          OUTQ(&PRT) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(AJBR20)
             DLTOVR     FILE(*ALL)

             ENDPGM
