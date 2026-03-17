 PGM
/** FBCC60 ************************************************/
/*  SALES UNIT PRICE M/F INQUIRY BY INTERNAL PART NO      */
/*       TOYOTA,OTHER CUSTOMER                            */
/*                                                        */
/* TCHK1 03/20/09 CREATE                                  */
/**********************************************************/
             DCL        VAR(&US)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WS) USER(&US)
             CHGVAR     VAR(&WSID) VALUE(%SST(&WS 1 1))

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

             CALL       PGM(FBCR60A)

 END:
             ENDPGM
