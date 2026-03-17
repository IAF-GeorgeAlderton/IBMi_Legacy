 PGM
/** AFDC20 ************************************************/
/*  OUTGOING:ORDER LATE RECEIVED LIST                     */
/*                                                        */
/* TCHK1  : 10/08/07 CREATE                               */
/**********************************************************/

             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&TDATE) TYPE(*CHAR) LEN(8) +
                                    VALUE('        ')
             DCL        VAR(&RSLT)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CLRPFM     FILE(HWFILE1/AFDWP20)
             OVRDBF     FILE(AFDWP20) TOFILE(HWFILE1/AFDWP20)
             OVRDBF     FILE(AFDWL20) TOFILE(HWFILE1/AFDWL20)

             CALL       PGM(AFDR20) PARM(&RSLT &TDATE)

             IF         (&RSLT *EQ '1') THEN(DO)

             OVRPRTF    FILE(QPRINT) OUTQ(QPRINT) HOLD(*YES)

             CALL       PGM(AFDR21) PARM(&TDATE)

             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132A)
             CALL       PGM(AB#RW0)
             SNDDST     TYPE(*FILE) TOINTNET(                       +
                          (tanebek@iafi.com)                +
                                            )                       +
                          DSTD('Outsource Order Late Received List.') +
                          MSG('Please check attached list.')        +
                          DOCFILE(HWFILE1/PRT132A)                  +
                          DOCTYPE(*FFT)                             +
                          SNDFMT(*NOTE)                             +
                          DOCD('Outsource Order Late Received List.')
             DLTOVR     FILE(PRT132)
             DLTSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)
             ENDDO

             DLTOVR     FILE(*ALL)

 ENDPGM
