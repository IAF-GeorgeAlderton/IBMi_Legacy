             PGM
             /** ASAC22 ************************************/
             /* A-PICS LIST PUBLICATION STANDSTILL LIST CREATE*/
             /*          M-OKUDA        1986.11.07         */
             /**********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSNO) USER(&USER)

      /*     CALL       KZZR00 PARM(&WSNO &PRT &TYPE &PRTG)         */
             CALL       PGM(AGAR01) PARM(&WSNO &PDEVT &PIGCD)
             CALL       AGAR00 PARM(&WSNO &PRT &TYPE &PRTG)

             OVRPRTF    FILE(ASAPR22) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(66) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(ASAR22)
             DLTOVR     FILE(ASAPR22)

 END:        ENDPGM
