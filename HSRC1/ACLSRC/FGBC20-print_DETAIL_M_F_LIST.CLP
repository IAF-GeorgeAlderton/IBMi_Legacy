             PGM
             /** FGBC20 **********************************/
             /*  ISSUE DETAIL M/F LIST                   */
             /* DATE   (CODING)  : 97.03.20    K.OKACHI  */
             /********************************** FGBC20 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&US)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1)
             CALL       PGM(FGBR20) PARM(&US)
             DLTOVR     FILE(QPRINT)

             ENDPGM
