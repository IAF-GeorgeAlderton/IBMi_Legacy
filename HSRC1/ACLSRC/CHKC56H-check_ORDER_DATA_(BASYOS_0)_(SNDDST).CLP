             PGM
             /** CHKC56H *********************************************/
             /*  CHECK ORDER DATA (BASYOS=0)                         */
             /*  ADD JOB TO VJBC71 (RUN 5:45AM EVERY DAY)            */
             /*  ADD JOB TO VJBC72 (RUN 4:30PM EVERY DAY)            */
             /*  J.WATANABE 2021.13.30                               */
             /********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&SRC ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&SIGN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DAYS) TYPE(*CHAR) LEN(4)
             DCL        VAR(&IAF)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&TGT ) TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
/* CHECK ORDER */
             CALL       PGM(HOBJ1/CHKR56H) PARM('Y' &RTN)

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
                          TOINTNET((Kaz.Watanabe@iafi.com)) +
                          DSTD('** ERROR ** ORDER QPC=0') MSG('** +
                          PP10 QPC=0 ** QPC=0 in PP10. (CHKC56H).') +
                          DOCFILE(QTEMP/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('ORDER QPC=0')
             DLTOVR     FILE(PRT132)
             ENDDO


             ENDPGM
