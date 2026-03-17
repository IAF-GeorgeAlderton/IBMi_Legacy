             PGM
             /** CHKC61J *********************************************/
             /*  FORD ORDER SHIPPING STATUS REPORT                   */
             /*  ADD JOB TO FCKC03  (JOB SCHEDULE: 7:33AM)           */
             /*  J.WATANABE 2023.01.19                               */
             /********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&SRC ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CALL       PGM(CHKR61J) PARM(&RTN)

        /**  IF         COND(&RTN = ' ') THEN(GOTO ENDP)  **/

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
                          DSTD('FORD ORDER SHIPPING STATUS REPORT') +
                          MSG('** NOTE ** CHECK FORD ORDER SHIPPING +
                          STATUS (CHKC61J).') +
                          DOCFILE(QTEMP/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('CHECK FORD ORDER +
                          SHIPPING STATUS')

             DLTOVR     FILE(PRT132)
 ENDP:
             ENDPGM
