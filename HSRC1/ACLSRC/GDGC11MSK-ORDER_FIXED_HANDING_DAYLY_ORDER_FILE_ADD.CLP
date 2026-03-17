             PGM
             /** GDGC11 *******************************************/
             /* ORDER FIXED HANDING / DAYLY ORDER FILE ADD&CHANGE */
             /*   G.B.C                                97/02/18   */
             /******************************************* GDGC11 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QGPL/ASJOUTQ) +
                          FORMTYPE(K6H1) HOLD(*YES)
             CALL       PGM(GDGR11) PARM(&USER)
             DLTOVR     FILE(QPRINT)

             ENDPGM
