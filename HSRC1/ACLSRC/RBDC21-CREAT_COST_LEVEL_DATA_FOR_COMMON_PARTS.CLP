             PGM
             /** RBDC21 **************************************/
             /*  .. CREAT COST LEVEL DATA FOR COMMON PARTS ..*/
             /*       I-HASADA                91.03.30       */
             /*       GBC                   2000.07.14       */
             /************************************** RBDC21 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CYYMM) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MCEDP01) TYPE(*CHAR) LEN(8)

             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)
             CHGVAR     VAR(&CYYMM) VALUE(%SUBSTRING(&MCEDP01 3 4))
             RTVJOBA    JOB(&WSID)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(QPRINTA) FORMTYPE(K6H1)
             CALL       PGM(RBDR22) PARM(&CYYMM)
             DLTOVR     FILE(QPRINT)

             ENDPGM
