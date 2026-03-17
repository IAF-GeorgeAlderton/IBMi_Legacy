             PGM
             /** CHKC37B *********************************************/
             /* CHECK ORDER (INVOICE#=BLANK)                         */
             /*  ADD JOB TO VJBC71  (JOB SCHEDULE  05:45 AM)         */
             /*  ADD JOB TO FCKC00  (JOB SCHEDULE: 10:10 AM)         */
             /*  J.WATANABE 2022.05.26                               */
             /********************************************************/
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&UPD)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&UPD) VALUE('Y')

/* CHECK INVOICE=BLANK (AB#PP10) */

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(CHKR37B) PARM(&RTN)

             IF         (&RTN *EQ '*') THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132A)
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((Kaz.Watanabe@iafi.com)) +
                          DSTD('** INVOICE# BLANK **') MSG('** +
                          INVOICE=BLANK ** Please Fix Invoice# in +
                          AB#PP10! Please check attached report. +
                          (CHKC37B).') DOCFILE(HWFILE1/PRT132A) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('** +
                          ERROR ** INVOICE# = BLANK (PP10)')
             DLTOVR     FILE(PRT132)
             ENDDO


             DLTOVR     FILE(QPRINT)

             ENDPGM
