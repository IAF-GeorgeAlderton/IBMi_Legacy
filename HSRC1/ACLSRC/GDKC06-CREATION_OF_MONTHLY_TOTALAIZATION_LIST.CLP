             PGM
             /**** GDKC06 ****************************************************/
             /*      CREATION OF MONTHLY TOTALAIZATION LIST                  */
             /*       GBC                               97/07/30             */
             /****************************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          198) LPI(6) CPI(15) OVRFLW(60) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1)
             CALL       PGM(GDKR06)
             DLTOVR     FILE(QPRINT)

             ENDPGM
