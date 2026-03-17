             PGM
             /** CHKC83 **********************************************/
             /*  CHECK 99999999 FOR AKBPP01                          */
             /*  ADD JOB TO VJBC71  (JOB SCHEDULE  05:45 AM)         */
             /*  ADD JOB TO VJBC72  (JOB SCHEDULE  16:30 PM)         */
             /*  J.WATANABE 2021.11.09                               */
             /********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(HOBJ1/CHKR83) PARM(&RTN)

             IF         (&RTN *EQ '*') THEN(DO)
             CRTDUPOBJ  OBJ(PRT132A) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/PRT132A)
             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(QTEMP/PRT132A)
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) TOINTNET((Kaz.Watanabe@iafi.com) +
                          (Takanao.Kato2@iafi.com)) DSTD('INVALID +
                          EXP DATE in WASHER KANBAN') MSG('** EXP +
                          DATE=9999 Error ** INVALID EXP DATE in +
                          WASHER KANBAN. (CHKC83).') +
                          DOCFILE(QTEMP/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('INVALID EXP DATE in +
                          WASHER KANBAN')
             DLTOVR     FILE(PRT132)
             ENDDO


             ENDPGM
