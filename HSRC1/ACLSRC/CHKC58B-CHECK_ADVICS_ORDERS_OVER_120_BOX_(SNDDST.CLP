             PGM
             /** CHKC58B *********************************************/
             /*  CHECK ADVICS ORDERS OVER 120 BOX                    */
             /*  ADD TO VJBC71 (SCHEDULED JOB AT 5:45AM)             */
             /*  J.WATANABE 2019.11.04                               */
             /********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(HOBJ1/CHKR58B) PARM(&RTN)

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
                          TOINTNET((Production.Control@iafi.com)) +
                          DSTD('** ADVICS ORDERS OVER 120 BOX **') +
                          MSG('** Note ** check ADVICS ORDERS OVER +
                          120 BOX. It need Master Labels for each +
                          pallet. (CHKC58B).') +
                          DOCFILE(QTEMP/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('CHECK ADVICS ORDERS +
                          OVER 120 BOX ')
             DLTOVR     FILE(PRT132)
             ENDDO

             ENDPGM
