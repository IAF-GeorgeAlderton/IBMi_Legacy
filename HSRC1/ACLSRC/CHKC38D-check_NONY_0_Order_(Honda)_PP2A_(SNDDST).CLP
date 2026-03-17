             PGM
             /** CHKC38D *********************************************/
             /*  CHECK NONY=0 ORDER (HONDA)     -PP2A                */
             /*  ADD JOB TO VJBC71  (JOB SCHEDULE  05:45 AM)         */
             /*  ADD JOB TO FCKC00  (JOB SCHEDULE: 10:10 AM)         */
             /*  J.WATANABE 2020.11.20                               */
             /********************************************************/
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)
        /*** DCL        VAR(&UPD)  TYPE(*CHAR) LEN(1)  ***/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&RTN) VALUE(' ')
        /*** CHGVAR     VAR(&UPD) VALUE('Y')           ***/

/* DELETE QTY=0 ORDER (HONDA)  */

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES) +
                          USRDTA('ACNONY=0')
             CALL       PGM(CHKR38D) PARM(&RTN)

             IF         (&RTN *EQ '*') THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132A)
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((ProductionControl@iafi.com) +
                          (SalesGroup@iafi.com)) DSTD('** ERROR ** +
                          (HONDA) FOUND DELIVERY CODE is 0') +
                          MSG('** DELIVERY CODE ERROR ** Delivery +
                          Code is 0! Please check attached report. +
                          (CHKC38D).') DOCFILE(HWFILE1/PRT132A) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('** +
                          ERROR ** DELIVERY CODE = 0 (PP2A)')
             DLTOVR     FILE(PRT132)
             ENDDO

             DLTOVR     FILE(QPRINT)

             ENDPGM
