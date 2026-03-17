             PGM
             /** CHKC24 **********************************************/
             /*  PRINT PART WITH MORE THAN $50 UNIT PRICE  -         */
             /*  ADD JOB TO FCKC00  (JOB SCHEDULE: 10:10 AM)         */
             /*  J.WATANABE 2022.03.11                               */
             /********************************************************/
             DCL        VAR(&CNT)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(CHKR24) PARM(&CNT)

             IF         (&CNT *NE '0000') THEN(DO)
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
                          DSTD('*** Uint Price more than $50 ***') +
                          MSG('*** Incorrect Unit price been found +
                          *** Please fix it to prevent from future +
                          issue. (CHKC24).') DOCFILE(QTEMP/PRT132A) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('*** +
                          INCORRECT UNIT PRICE ***')
             DLTOVR     FILE(PRT132)
             ENDDO

             DLTOVR     FILE(QPRINT)

             ENDPGM
