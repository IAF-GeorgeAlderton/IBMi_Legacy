             PGM
             /** CHKC74 **********************************************/
             /*  PRINT SUBARU QUICK SHIP ORDER REPORT                */
             /*  ADD JOB TO AB#C0A                                   */
             /*  J.WATANABE 2019.07.24                               */
             /********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&SRC ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(HOBJ1/CHKR74B) PARM(&RTN)

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
                          DSTD('Check SUBARU QUICK SHIP ORDER') +
                          MSG('** Note ** check SUBARU QUICK SHIP +
                          ORDER. (CHKC74).') DOCFILE(QTEMP/PRT132A) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('CHECK +
                          SUBARU QUICK SHIP ORDER')
             DLTOVR     FILE(PRT132)
             ENDDO

 /* PRINT FOR PC */
             IF         COND((&USER *NE 'I0777') *AND (USER *NE +
                          'TEST')) THEN(DO)
             SNDDST     TYPE(*FILE) +
                          TOINTNET((ProductionControl@iafi.com)) +
                          DSTD('Check SUBARU QUICK SHIP ORDER') +
                          MSG('** Note ** check SUBARU QUICK SHIP +
                          ORDER. (CHKC74).') DOCFILE(QTEMP/PRT132A) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('CHECK +
                          SUBARU QUICK SHIP ORDER')
             DLTOVR     FILE(PRT132)
             ENDDO

             ENDDO

             ENDPGM
