             /**** GDGC04 ****************************************************/
             /*      PRINT INVENTORY UNIT PRICE M/F LIST                     */
             /*       GBC                               97/02/20             */
             /****************************************************************/
             PGM
             DCLF       FILE(GDJPW04)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 ##1:        SNDRCVF    RCDFMT(DSP01)
             IF  (&IN01 = '1')  GOTO END
             IF  (&IN05 = '1')  GOTO ##2
             GOTO ##1

 ##2:
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(158) +
                          LPI(6) CPI(12) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(GDJR04)
             DLTOVR     FILE(QPRINT)

 ##3:
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(158) +
                          LPI(6) CPI(12) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(GDJR07)
             DLTOVR     FILE(QPRINT)

END:         ENDPGM
