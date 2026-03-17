/** AB#C5M ************************************************/
/*  PRINT DCL COMPARISON REPORT                           */
/*                                                        */
/*  JW   2017.01.06                                       */
/**********************************************************/
             PGM

             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&US2)   TYPE(*CHAR) LEN(2)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
/* SET PRINTER */
             CHGVAR     VAR(&US2) VALUE(%SUBSTRING(&USER 1 2))

             IF         COND(&US2 *EQ 'I3') THEN(CHGVAR VAR(&PRTG) +
                          VALUE('LANPRT50'))

             IF         COND(&US2 *EQ 'I0') THEN(CHGVAR VAR(&PRTG) +
                          VALUE('LANPRT03'))

/* SET UP HONDA GROUP FLAG IN EDIPP42 */
             CALL       PGM(EDIR41)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)

             CALL       PGM(AB#R5M)

 END:        ENDPGM
