             PGM
             /** CHKC50 **********************************************/
             /*  CHECK ORDER DATA                                    */
             /*  ADD JOB TO VJBC71  (JOB SCHEDULE  05:45 AM)         */
             /*  ADD JOB TO FCKC00  (JOB SCHEDULE: 10:10 AM)         */
             /*  J.WATANABE 2019.05.28                               */
             /********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

/* JW STOPPED 2019.10.21 */
/**          GOTO       CMDLBL(ENDP)  **/

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(HOBJ1/CHKR50) PARM(&RTN)

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
                          DSTD('Check Order Data...') MSG('** Note +
                          ** check Order Data. (CHKC50).') +
                          DOCFILE(QTEMP/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('CHECK ORDER DATA')
             DLTOVR     FILE(PRT132)
             ENDDO


ENDP:        ENDPGM
