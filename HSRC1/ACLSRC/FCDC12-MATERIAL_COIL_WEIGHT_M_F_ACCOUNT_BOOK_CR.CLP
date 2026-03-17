             PGM
             /** FCDC12 *****************************************/
             /* MATERIAL COIL WEIGHT M/F ACCOUNT BOOK CREATE    */
             /*            M-OKUDA        1986.01.22            */
             /***************************************************/
             DCL        VAR(&US)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7) VALUE(QPRINT )
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID) USER(&US)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) OUTQ(&PRT) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(FCDR12)
             DLTOVR     FILE(QPRINT)

             ENDPGM
