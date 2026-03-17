  PGM
/** AN#CFS ************************************************/
/*  ANDROID FUTRE FORD ORDER LIST                         */
/*                                                        */
/* TCHK1 08/01/06 CREATE(COPY FROM AB#CFS)                */
/**********************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USID) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USID)

    /* PRINT DATA LIST */
             OVRPRTF    FILE(QPRINT) PAGESIZE(66 198) CPI(15) +
                          OUTQ(QPRINTB)
             CALL       PGM(AN#RFS) PARM(&USID)
             DLTOVR     FILE(QPRINT)

 END:
             ENDPGM
