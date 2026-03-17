 PGM
/** FBCC50 ************************************************/
/*  SALES UNIT PRICE UPDATED LIST                         */
/*                                                        */
/* TCHK1  : 08/06/07 CREATE                               */
/**********************************************************/

             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&TDATE) TYPE(*CHAR) LEN(8) +
                                    VALUE('        ')
             DCL        VAR(&RSLT)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)

             CALL       PGM(FBCR50) PARM(&TDATE &RSLT)

             DLTOVR     FILE(QPRINT)

             IF         (&RSLT *EQ '1') THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132A)
             CALL       PGM(AB#RW0)
             SNDDST     TYPE(*FILE) +
                          TOINTNET((AS400PriceUpdate@iafi.com) +
                          (SalesGroup@iafi.com)) DSTD('Sales Unit +
                          Price Changed Log List') MSG('Please +
                          check attached list. (FBCC50)') +
                          DOCFILE(HWFILE1/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('Sales unit price +
                          changed Log List.')
             DLTOVR     FILE(PRT132)
             ENDDO

             DLTOVR     FILE(*ALL)

 ENDPGM
