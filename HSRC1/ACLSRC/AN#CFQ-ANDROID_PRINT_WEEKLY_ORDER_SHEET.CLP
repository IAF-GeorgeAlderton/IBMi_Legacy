  PGM
/** AN#CFQ ************************************************/
/*  ANDROID PRINT WEEKLY ORDER SHEET                      */
/*                                                        */
/* TCHK1 07/28/06 CREATE(COPY FROM AB#CFQ)                */
/**********************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USID) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USID)

             CALL       PGM(AN#RFQ) PARM(&USID)

 END:
             ENDPGM
