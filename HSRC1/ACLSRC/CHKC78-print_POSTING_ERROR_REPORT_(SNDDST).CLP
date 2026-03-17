             PGM
             /** CHKC78 **********************************************/
             /*  PRINT POSTING ERROR REPORT                          */
             /*  ADD JOB TO VJBC71  (JOB SCHEDULE  05:45 AM)         */
             /*  J.WATANABE 2020.01.31                               */
             /********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&SRC ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CHGVAR     VAR(&DATE) VALUE('20200120')

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(HOBJ1/CHKR78) PARM(&DATE &RTN)

 /* SEND ERROR MSG BY MAIL */
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
                          DSTD('POSTING ERROR REPORT') MSG('** Note +
                          ** check POSTING ERROR REPORT. +
                          (CHKC78).') DOCFILE(QTEMP/PRT132A) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) +
                          DOCD('POSTING ERROR REPORT')
             DLTOVR     FILE(PRT132)
             ENDDO
             ENDDO

 /* SEND NO ERROR MSG BY MAIL */
             IF         (&RTN *EQ ' ') THEN(DO)
             SNDDST     TYPE(*LMSG) +
                          TOINTNET((Kaz.Watanabe@iafi.com)) +
                          DSTD('POSTING ERROR REPORT') LONGMSG('** +
                          POSTING DOES NOT HAVE ANY ERRORS ** +
                          (CHKC78).') DOCD('POSTING ERROR REPORT')
             ENDDO

             ENDPGM
