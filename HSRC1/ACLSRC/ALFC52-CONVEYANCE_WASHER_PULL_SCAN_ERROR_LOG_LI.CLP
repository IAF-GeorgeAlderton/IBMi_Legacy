/** ALFC02B ***********************************************/
/*  CONVEYANCE WASHER PULL SCAN ERROR LOG LIST            */
/*                                                        */
/* LEC   2018/12/10   COPY FROM ALFC02                    */
/**********************************************************/
 PGM  PARM(&FRDT &TODT &RFLG &PRTR)

             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)   TYPE(*CHAR) LEN(6)

             DCL        VAR(&FRDT)  TYPE(*CHAR) LEN(12)
             DCL        VAR(&TODT)  TYPE(*CHAR) LEN(12)
             DCL        VAR(&RFLG)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTR)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             IF         (&PRTR  *EQ '9' *OR &PRTR  *EQ 'E') THEN(DO)
             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ)   +
                            PAGESIZE(66 132) LPI(6)   +
                            OVRFLW(60) FORMTYPE(K6H1) +
                            HOLD(*YES)
             ENDDO
             ELSE DO
             IF         COND(&PRTR *EQ '2') THEN(OVRPRTF +
                          FILE(QPRINT) PAGESIZE(66 132) LPI(6) +
                          OVRFLW(60) OUTQ(LANPRT31) FORMTYPE(K6H1))
             IF         COND(&PRTR *NE '2') THEN(OVRPRTF +
                          FILE(QPRINT) PAGESIZE(66 132) LPI(6) +
                          OVRFLW(60) OUTQ(LANPRT10) FORMTYPE(K6H1))
             ENDDO

             CALL       PGM(ALFR52) PARM(&FRDT &TODT &RFLG)

 /*************************************************************************/
             IF         (&PRTR *EQ 'E') THEN(DO)
             IF         (&RFLG *EQ '1') THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132A)
             CALL       PGM(AB#RW0)
             SNDDST     TYPE(*FILE) TOINTNET((Conveyance@iafi.com)) +
                          DSTD('Conveyance +
                          Washer error Log List') MSG('Please check +
                          attached list. (ALFC02B)') +
                          DOCFILE(HWFILE1/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('Conveyance Washer +
                          error Log List.')
             DLTOVR     FILE(PRT132)
             ENDDO
             ENDDO
 /*************************************************************************/

             DLTOVR     FILE(*ALL)

 ENDPGM
