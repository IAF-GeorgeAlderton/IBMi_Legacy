             PGM
             /***MBDC12********************************************/
             /* PART NUMBER ORDER  DELIVERY STATISTICAL LIST. */
             /*            A-SANGA 1981.11.12                     */
             /*****************************************************/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WS)
             CHGJOB     RUNPTY(40)
             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             OVRPRTF    FILE(QPRINT) TOFILE(*FILE) DEVTYPE(&PDEVT) +
                          PAGESIZE(88 132) LPI(8) OVRFLW(84) +
                          RPLUNPRT(*YES) OUTQ(&PRT) FORMTYPE(K8H1) +
                          COPIES(1) IGCDTA(&PIGCD)
             CALL       PGM(MBDR12)
             DLTOVR     FILE(QPRINT)

             CHGJOB     RUNPTY(20)

             ENDPGM
