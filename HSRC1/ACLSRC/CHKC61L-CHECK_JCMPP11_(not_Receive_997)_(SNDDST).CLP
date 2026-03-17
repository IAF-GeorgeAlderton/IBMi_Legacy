             PGM
             /** CHKC61L *********************************************/
             /*  CHECK JCMPP11 (NOT RECEIVE 997)                     */
             /*  ADD JOB TO CHKC01  (JOB SCHEDULE: EVERY 1 HOUR)     */
             /*  J.WATANABE 2025.04.17                               */
             /********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&SRC ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CALL       PGM(CHKR61L) PARM(&RTN)

             IF         COND(&RTN = ' ') THEN(GOTO ENDP)

             CRTDUPOBJ  OBJ(PRT132A) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/PRT132A)
             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(QTEMP/PRT132A)
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((kaz.watanabe@iafi.com)) +
                          DSTD('FORD 997 ERROR REPORT') MSG('** +
                          ERROR ** FORD 997 ERROR REPORT. +
                          (CHKC61L).') DOCFILE(QTEMP/PRT132A) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('FORD +
                          997 ERROR REPORT')

             DLTOVR     FILE(PRT132)
 ENDP:
             ENDPGM
