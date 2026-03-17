  PGM
/***********************************************************/
/*  TS LINE DOWNLOAD DATA CREATE                           */
/*                                                         */
/* TCHK1 09/241/10 CREATE                                  */
/***********************************************************/
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&US)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WS) USER(&US)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&US &WLIB)

             CLRPFM     FILE(HWFILE1/TSLINEF)
             CLRPFM     FILE(HWFILE1/FCDWP9F)

             CALL       PGM(FCDR9F)
 END:
             ENDPGM
