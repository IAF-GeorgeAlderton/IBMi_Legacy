/**** GDKC01 ****************************************************/
/*      UNIT PRICE MASTER UPDATE & REFERENCE                    */
/*       GBC                               97/07/30             */
/****************************************************************/
             PGM
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

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          198) LPI(6) CPI(15) RPLUNPRT(*YES) +
                          OUTQ(ASJOUTQ) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(GDKR01) PARM(&USER)
             DLTOVR     QPRINT

             ENDPGM
