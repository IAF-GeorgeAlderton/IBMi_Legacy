             PGM
             /**** GDKC02 ****************************************************/
             /*      UNIT PRICE MASTER LIST                                  */
             /*       GBC                               97/07/30             */
             /****************************************************************/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             RTVJOBA    JOB(&JOB)

             CALL       PGM(AGAR00) PARM(&JOB &PRT &TYPE &PRTG)

             OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1)
             CALL       PGM(GDKR02)
             DLTOVR     FILE(QPRINT)

             ENDPGM
