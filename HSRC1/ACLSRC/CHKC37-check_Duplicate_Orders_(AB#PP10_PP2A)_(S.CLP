             PGM
             /** CHKC37 **********************************************/
             /*  PRINT CHECK LISTS                                   */
             /*  ADD JOB TO VJBC71  (JOB SCHEDULE  05:45 AM)         */
             /*  ADD JOB TO FCKC00  (JOB SCHEDULE: 10:10 AM)         */
             /*    1. CHECK  DUPLICATE ORDER    (AB#PP10)            */
             /*    2. CHECK  DUPLICATE ORDER    (AB#PP2A)            */
             /*    3. CHECK  DUPLICATE FORECAST (ABBPP01)            */
             /*    3B DELETE DUPLICATE FORECAST (ABBPP01)            */
             /*                                                      */
             /*  J.WATANABE 5/2/2016                                 */
             /********************************************************/
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

/* CHECK DUPLICATE ORDERS (AB#PP10) */

             OVRPRTF    FILE(QPRINT) PAGESIZE(80 198) LPI(8) CPI(15) +
                          OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(CHKR37) PARM(&RTN)

             IF         (&RTN *EQ '*') THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT198 ) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT198) TOFILE(HWFILE1/PRT198 )
             CALL       PGM(AB#RW1)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((Kaz.Watanabe@iafi.com)) +
                          DSTD('** ERROR ** Duplicate Order PP10') +
                          MSG('** DUPLICATE ORDER ** Duplicate +
                          Order Found in AB#PP10! Please check +
                          attached report. (CHKC37-1).') +
                          DOCFILE(HWFILE1/PRT198) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('** ERROR ** +
                          DUPLICATE ORDER (PP10)')
             DLTOVR     FILE(PRT198)
             ENDDO

/* CHECK DUPLICATE ORDERS (AB#PP2A) */

             OVRPRTF    FILE(QPRINT) PAGESIZE(80 198) LPI(8) CPI(15) +
                          OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(CHKR38) PARM('Y' &RTN)

             IF         (&RTN *EQ '*') THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT198 ) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT198) TOFILE(HWFILE1/PRT198 )
             CALL       PGM(AB#RW1)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((Kaz.Watanabe@iafi.com)) +
                          DSTD('** ERROR ** Duplicate Order PP2A') +
                          MSG('** DUPLICATE ORDER ** Duplicate +
                          Order Found in AB#PP2A! Please check +
                          attached report. (CHKC37-2).') +
                          DOCFILE(HWFILE1/PRT198) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('** ERROR ** +
                          DUPLICATE ORDER (PP2A)')
             DLTOVR     FILE(PRT198)
             ENDDO

/* CHECK DUPLICATE ORDERS (ABBPP01) */

             OVRPRTF    FILE(QPRINT) PAGESIZE(80 198) LPI(8) CPI(15) +
                          OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(CHKR39) PARM(&RTN)

             IF         (&RTN *EQ '*') THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT198 ) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT198) TOFILE(HWFILE1/PRT198 )
             CALL       PGM(AB#RW1)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((Kaz.Watanabe@iafi.com)) +
                          DSTD('** ERROR ** Duplicate Order ABBPP01 +
                          (FC)') MSG('** DUPLICATE ORDER ** +
                          Duplicate Order Found in ABBPP01 +
                          (Forecast). (CHKC37-3).') +
                          DOCFILE(HWFILE1/PRT198) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('** ERROR ** +
                          DUPLICATE ORDER (ABBPP01)')
             DLTOVR     FILE(PRT198)

 /**JW DELETE DUPLICATED FORECAST **/

             CALL       PGM(CHKR39A)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT198 ) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT198) TOFILE(HWFILE1/PRT198 )
             CALL       PGM(AB#RW1)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((Kaz.Watanabe@iafi.com)) +
                          DSTD('** NOTE ** DELETED Duplicate Order +
                          ABBPP01') MSG('** DELETED DUP ORDER ** +
                          Duplicate Order Deleted (Forecast). +
                          (CHKC37-4).') DOCFILE(HWFILE1/PRT198) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('** +
                          NOTE ** DELETED DUPLICATE ORDER (ABBPP01)')
             DLTOVR     FILE(PRT198)

             ENDDO

             DLTOVR     FILE(QPRINT)

             ENDPGM
