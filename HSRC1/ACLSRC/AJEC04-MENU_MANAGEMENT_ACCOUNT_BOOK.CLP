             PGM
             /** AJEC04 ********************/
             /*   MENU MANAGEMENT ACCOUNT BOOK   */
             /* I-HASADA 95.12.21 */
             /******************** AJEC04 **/
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

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(33 80) +
                          LPI(6) OVRFLW(32) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6S1) IGCDTA(&PIGCD)
             CALL       PGM(AJER04) PARM(&USER)
             DLTOVR     FILE(QPRINT)

             ENDPGM
