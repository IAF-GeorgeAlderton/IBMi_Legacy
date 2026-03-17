             PGM
             /** AAKC13 ************************************/
             /*INRTAL COMPANY SERVICE BIN TIME SCHEDULE CREATE CL */
             /*          M S K          1987.04.25         */
             /**********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSNO) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSNO &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

             OVRPRTF    FILE(AAKPR13) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(66) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(AAKR13) PARM(&USER)
             DLTOVR     FILE(AAKPR13)

 END:        ENDPGM
