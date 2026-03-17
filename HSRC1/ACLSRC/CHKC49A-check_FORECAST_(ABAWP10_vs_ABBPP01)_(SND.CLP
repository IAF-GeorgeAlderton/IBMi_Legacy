             PGM
             /** CHKC49A *********************************************/
             /*  CHECK FORECAST (ABAWP10 VS ABBPP01)                 */
             /*  ADD JOB TO VJBC72 (RUN 4:30PM EVERY DAY)            */
             /*  J.WATANABE 2023.05.11                               */
             /********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(HOBJ1/CHKR49A) PARM('N' &RTN)

             IF         (&RTN *EQ '*') THEN(DO)
             CRTDUPOBJ  OBJ(PRT132A) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/PRT132A)
             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(QTEMP/PRT132A)
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((Kaz.Watanabe@iafi.com)) +
                          DSTD('FORECAST DISCREPANCY') MSG('** +
                          FORECAST DISCREPANCY ** ABAWP10 vs +
                          ABBPP01 ERROR. (CHKC49A).') +
                          DOCFILE(QTEMP/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('FORECAST DISCREPANCY')
             DLTOVR     FILE(PRT132)
             ENDDO


             ENDPGM
