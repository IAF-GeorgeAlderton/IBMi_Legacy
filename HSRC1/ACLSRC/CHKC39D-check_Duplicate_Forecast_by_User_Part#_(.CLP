             PGM
             /** CHKC39D *********************************************/
             /*  CHECK DUPLICATE FORECAST BY USER PART#              */
             /*  ADD JOB TO VJBC71  (JOB SCHEDULE  05:45 AM)         */
             /*  ADD JOB TO VJBC72  (JOB SCHEDULE: 16:30 PM)         */
             /*  J.WATANABE 2023.02.15                               */
             /********************************************************/
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&RTN) VALUE(' ')

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES) +
                          USRDTA('DUP_FCST')
             CALL       PGM(CHKR39D) PARM('Y' &RTN)

             IF         (&RTN *EQ '*') THEN(DO)
             DLTF       FILE(QTEMP/PRT132A)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ OBJ(PRT132A) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(QTEMP/PRT132A)
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((kaz.watanabe@iafi.com)) +
                          DSTD('** ERROR ** FORECAST DUPLICATE +
                          REPORT **') MSG('** ERROR ** FORECAST +
                          DUPLICATE ERROR REPORT. PLEASE CONFIRM +
                          THE ATTACHED REPORT. (CHKC39D).') +
                          DOCFILE(QTEMP/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('** ERROR ** FORECAST +
                          DUPLICATE ERROR REPORT')
             DLTOVR     FILE(PRT132)
             ENDDO

             DLTOVR     FILE(QPRINT)

             ENDPGM
