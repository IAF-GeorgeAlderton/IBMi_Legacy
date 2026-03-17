             PGM
             /** AAQC02 ********************************/
             /* LOCATION CODE FUNCTION M/F LIST    */
             /*                     H.ITO 86.10.15 */
             /******************************** AAQC02 **/
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             /* DCL VAR(&KOTAE) TYPE(*CHAR) LEN(1) */
             /* DCL VAR(&MBAN)  TYPE(*CHAR) LEN(4) */
             RTVJOBA    JOB(&WS)

             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(AAQR02)
             DLTOVR     FILE(QPRINT)

 END:        ENDPGM
