             PGM
             /** AB#CFS **************************************/
             /* CALL AB#RFS(FUTRE FORD ORDER LIST)           */
             /* K.KASHIWAGI 2001.02.23                       */
             /************************************** AB#CFS **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USID) TYPE(*CHAR) LEN(10)

             DCL        VAR(&DFT ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)

    /* SELECT PRINTER */
             CHGVAR     VAR(&DFT) VALUE('6')
             CALL       PGM(UTLC79A) PARM(&DFT &OUTQ)

             RTVJOBA    JOB(&WSID) USER(&USID)

    /* PRINT DATA LIST */
             OVRPRTF    FILE(QPRINT) PAGESIZE(66 198) CPI(15) +
                          OUTQ(&OUTQ)
             CALL       PGM(AB#RFS) PARM(&USID)
             DLTOVR     FILE(QPRINT)

 END:
             ENDPGM
