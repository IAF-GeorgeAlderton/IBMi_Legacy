             PGM
             /** CHKC61H *********************************************/
             /*  CHECK ROUTE MASTER VS SHIP MASTER                   */
             /*  ADD JOB TO FCKC03  (JOB SCHEDULE: 07:33 AM)         */
             /*  J.WATANABE 2022.12.21                               */
             /********************************************************/

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&SRC ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&SIGN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DAYS) TYPE(*CHAR) LEN(4)
             DCL        VAR(&IAF)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&TGT ) TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CALL       PGM(CHKR61H) PARM(&RTN)

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
                          TOINTNET((ProductionControl@iafi.com)) +
                          DSTD('FORD ROUTE M/F VS SHIP M/F REPORT') +
                          MSG('** Fix Unmatch Delivery Code ** FORD +
                          ROUTE MASTER ERROR. (CHKC61H)') +
                          DOCFILE(QTEMP/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('FORD ROUTE M/F vs +
                          SHIP M/F REPORT')

             DLTOVR     FILE(PRT132)
 ENDP:
             ENDPGM
