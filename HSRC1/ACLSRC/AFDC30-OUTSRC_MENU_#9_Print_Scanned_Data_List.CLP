 PGM PARM(&SUPP &SUPX)
/** AFDC30 ************************************************/
/*  OUTGOING:ORDER SCANNED DATA LIST                      */
/*                                                        */
/* TCHK1 11/01/07 CREATE                                  */
/**********************************************************/

             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)   TYPE(*CHAR) LEN(6)

             DCL        VAR(&SUPP)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&SUPX)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CALL       PGM(AFDR30) PARM(&SUPP &SUPX)

 ENDPGM
