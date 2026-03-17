             PGM
             /** AB#C0N **********************************************/
             /*  PRICE CATALOG                                       */
             /*    H.AMANO       OCT/30/03                           */
             /*                                                      */
             /* TCHK1 11/16/05 CHG SNDDST                            */
             /* TCHK2 04/03/12 ADD MASTER UPDATE PROCESS(SUBMIT)     */
             /********************************************** AB#C0N **/
             DCL        VAR(&CNT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             OVRPRTF    FILE(QPRINT) OUTQ(EPRINT1) HOLD(*YES)
             CALL       PGM(AB#R0N)
             DLTOVR     FILE(QPRINT)

             RTVMBRD    FILE(AB#EP10) NBRCURRCD(&CNT)
             IF         (&CNT *GT 0) THEN(DO)

             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132A)
             CALL       PGM(AB#RW0)

/* TCHK1 */
             SNDDST     TYPE(*FILE) +
                          TOINTNET((EDI832PriceCatalog@iafi.com)) +
                          DSTD('EDI 832 Price Catalog') MSG('EDI +
                          price catalog(832) has been processed. +
                          Please check the attached list (AB#C0N).') +
                          DOCFILE(HWFILE1/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('EDI 832 price catalog')
/* TCHK1 */
             DLTOVR     FILE(PRT132)

/* TCHK2 */  SBMJOB     CMD(CALL PGM(AG#C10)) JOB(PRICEUPD) +
                          JOBD(QBATCH1) JOBQ(JOBQ1) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD)
/* TCHK2 */
             ENDDO

             ENDPGM
