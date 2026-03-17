             PGM
             /** CHKC38B *********************************************/
             /*  DELETE PROCESSED ORDER (HONDA) -PP2A                */
             /*  J.WATANABE 2020.06.30                               */
             /********************************************************/
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&UPD)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&UPD) VALUE('Y')

/* CHECK DUPLICATE ORDERS (AB#PP10) */

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(CHKR38B) PARM(&UPD &RTN)

             IF         (&RTN *EQ '*') THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132A)
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((Kaz.Watanabe@iafi.com)) +
                          DSTD('** ERROR ** (HONDA) FOUND ALREADY +
                          PROCESSED ') MSG('** PROCESSED ORDER ** +
                          Already Processed Order Found in AB#PP2A! +
                          Please check attached report. +
                          (CHKC38B).') DOCFILE(HWFILE1/PRT132A) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('** +
                          ERROR ** ALREADY PROCESSED ORDER (PP2A)')
             DLTOVR     FILE(PRT132)
             ENDDO


             DLTOVR     FILE(QPRINT)

             ENDPGM
