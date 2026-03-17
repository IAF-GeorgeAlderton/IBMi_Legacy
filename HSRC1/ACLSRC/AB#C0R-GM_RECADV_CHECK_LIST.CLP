             PGM
             /** AB#C0R **********************************************/
             /*  GM RECADV CHECK LIST                                */
             /*    H.AMANO       JAN/22/04                           */
             /*                                                      */
             /*                                                      */
             /********************************************** AB#C0R **/
             DCL        VAR(&CNT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)
             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL AB#R0R
             RTVMBRD    FILE(AB#EP82) NBRCURRCD(&CNT)
             IF         (&CNT *GT 0) THEN(DO)

             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132A)
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) TOINTNET((CoxA@iafi.com)) +
                          DSTD('EDI RECADV message') MSG('EDI +
                          RECADV (GM) has been processed.  Please +
                          check the attached list. (AB#C0R)') +
                          DOCFILE(HWFILE1/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('EDI RECASDV message')
             DLTOVR     FILE(PRT132)
             ENDDO
             DLTOVR     FILE(QPRINT)


             ENDPGM
