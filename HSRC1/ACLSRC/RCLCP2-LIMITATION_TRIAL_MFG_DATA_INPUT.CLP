             PGM
             /** RCLCP2 *****************************************/
             /* LIMITATION .TRIAL MFG DATA INPUT                              */
             /*            N.SHIBAYAMA 1984.07.17               */
             /***************************************** RCLCP2 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID) USER(&US)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) RPLUNPRT(*YES) OUTQ(&PRT) +
                          FORMTYPE(K6H1) COPIES(1) IGCDTA(&PIGCD)
             OVRPRTF    FILE(QPRINTS) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) RPLUNPRT(*YES) OUTQ(&PRT) +
                          FORMTYPE(K6H1) COPIES(1) IGCDTA(&PIGCD)
             CALL       PGM(RCLR21) PARM(&US)
             DLTOVR     FILE(QPRINT)
             DLTOVR     FILE(QPRINTS)

             ENDPGM
