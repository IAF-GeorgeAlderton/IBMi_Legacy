             PGM
             /** AGDC10 ***************************/
             /* ORDER ACCUMULATION DATA INQURIRY  */
             /*  KIRI 2015.07.09                  */
             /*************************************/
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE)     TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WS)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)


             CLRPFM     AGFWP10

             CALL       PGM(AGFR10)


 END:        ENDPGM
