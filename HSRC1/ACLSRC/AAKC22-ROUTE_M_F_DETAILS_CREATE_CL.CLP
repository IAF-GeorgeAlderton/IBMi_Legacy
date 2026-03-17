             PGM
             /** AAKC22 ************************************/
             /* ROUTE M/F DETAILS CREATE          CL */
             /*          M S K          1987.04.21         */
             /**********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSNO) USER(&USER)
             CALL       AGAR00 PARM(&WSNO &PRT &TYPE &PRTG)
             OVRPRTF    FILE(AAKPR22) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(64) OUTQ(QPRINTB) +
                          FORMTYPE(K6H1)
             CALL       PGM(AAKR22)
             DLTOVR     FILE(AAKPR22)
 END:        ENDPGM
