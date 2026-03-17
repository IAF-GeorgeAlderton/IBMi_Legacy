             PGM
             /** AAIC12 ************************************/
             /* CALCULATION BIN M/F ACCOUNT BOOK CREATE BY TIME CL */
             /*          M-OKUDA        1986.09.23         */
             /* CHANGE OUTQ                                */
             /*          K.KASHIWAGI    2001.04.23         */
             /**********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSNO) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

             OVRPRTF    FILE(AAIPR12) PAGESIZE(66 132) LPI(6) +
                          OVRFLW(60) OUTQ(QPRINT) FORMTYPE(K6H1)
             CALL       PGM(AAIR12)
             DLTOVR     FILE(AAIPR12)

 END:        ENDPGM
