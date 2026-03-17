             PGM
             /** CHKC79B *********************************************/
             /*  CHECK PACKING LIST# VS AB#PP10                      */
             /*  ADD JOB TO VJBC71  (JOB SCHEDULE:  5:45 AM)         */
             /*  ADD JOB TO FCKC00  (JOB SCHEDULE: 10:10 AM)         */
             /*  ADD JOB TO VJBC72  (JOB SCHEDULE: 16:30 PM)         */
             /*  J.WATANABE 2022.11.18                               */
             /********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&SRC ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

/*** TEMP ********/
GOTO CMDLBL(ENDP)
/*****************/

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(HOBJ1/CHKR79B) PARM(' '  'Y' &RTN)

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
                          DSTD('PACKING LIST# WITH PP10 ERROR +
                          REPORT') MSG('** Note ** Packing List +
                          Does Not Have Order(AB#PP10). +
                          (CHKC79B).') DOCFILE(QTEMP/PRT132A) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('** +
                          PACKING LIST ERROR REPORT **')
             DLTOVR     FILE(PRT132)
             ENDDO
             ENDDO

             GOTO       CMDLBL(ENDP)

 /* ======== IF &RTN=' ', THEN SEND NO ERROR MSG BY MAIL ======== */
             IF         (&RTN *EQ ' ') THEN(DO)
             SNDDST     TYPE(*LMSG) +
                          TOINTNET((Kaz.Watanabe@iafi.com)) +
                          DSTD('(TEST) NO ERROR REPORT') +
                          LONGMSG('(TEST) NO ERROR +
                          REPORT.(CHKC79B).') DOCD('(TEST) NO ERROR +
                          REPORT')
             ENDDO

ENDP:        ENDPGM
