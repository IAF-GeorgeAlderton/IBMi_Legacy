             PGM
             /** CHKC79 **********************************************/
             /*  CHECK PACKING LIST# VS VW ORDERS                    */
             /*  ADD JOB TO VJBC71  (JOB SCHEDULE  05:45 AM)         */
             /*  J.WATANABE 2020.02.14                               */
             /********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&SRC ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(HOBJ1/CHKR79) PARM(&RTN)

 /* ===== IF &RTN='*', THEN SEND ERROR MSG BY MAIL ===== */
             IF         (&RTN *EQ '*') THEN(DO)
             CRTDUPOBJ  OBJ(PRT132A) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/PRT132A)
             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(QTEMP/PRT132A)
             CALL       PGM(AB#RW0)

             /* PRINT FOR TEST */
             IF         COND((&USER *EQ 'I0777') *OR (USER *EQ +
                          'TEST')) THEN(DO)
             SNDDST     TYPE(*FILE) +
                          TOINTNET((Kaz.Watanabe@iafi.com)) +
                          DSTD('VW ORDER VS P/L# ERROR REPORT **') +
                          MSG('** Note ** VW ORDER (ABVPP20) does +
                          not exist. (CHKC79).') +
                          DOCFILE(QTEMP/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('VW ORDER VS P/L# +
                          ERROR REPORT **')
             DLTOVR     FILE(PRT132)
             ENDDO
             ENDDO

 /* ======== IF &RTN=' ', THEN SEND NO ERROR MSG BY MAIL ======== */
             IF         (&RTN *EQ ' ') THEN(DO)
             SNDDST     TYPE(*LMSG) +
                          TOINTNET((Kaz.Watanabe@iafi.com)) +
                          DSTD('VW ORDER VS P/L# ERROR REPORT **') +
                          LONGMSG('** VW ORDERS (ABVPP20) DOES NOT +
                          HAVE ANY ERRORS ** (CHKC79).') +
                          DOCD('POSTING ERROR REPORT')
             ENDDO

             ENDPGM
