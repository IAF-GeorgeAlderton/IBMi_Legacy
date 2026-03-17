             PGM
             /** CHKC52 **********************************************/
             /*  CHECK ORDERS SELECTED BY CREATE DATE                */
             /*  ADD JOB TO FCKC00  (JOB SCHEDULE: 10:10 AM)         */
             /*  J.WATANABE 2019.06.04                               */
             /********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&SRC ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&SIGN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DAYS) TYPE(*CHAR) LEN(4)
             DCL        VAR(&IAF)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&TGT ) TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

/* GET TODAY */
             CHGVAR     VAR(&SRC ) VALUE(' ')
             CALL       PGM(UTLR01) PARM(&SRC &DATE &RTN)

/* GET YESTERDAY */
             CHGVAR     VAR(&SIGN) VALUE('-')
             CHGVAR     VAR(&DAYS) VALUE('0001')
             CHGVAR     VAR(&IAF ) VALUE('N')
             CALL       PGM(UTLR10) PARM(&DATE &SIGN &DAYS &IAF &TGT &RTN)


             CHGVAR     VAR(&TYPE) VALUE(' ')
             OVRPRTF    FILE(QPRINT) PAGESIZE(66 198) LPI(6) CPI(15) +
                          OVRFLW(63) OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(HOBJ1/CHKR52) PARM(&TGT &TYPE &RTN)

             IF         (&RTN *EQ '*') THEN(DO)
             CRTDUPOBJ  OBJ(PRT198 ) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/PRT198 )
             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT198 ) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT198) TOFILE(QTEMP/PRT198 )
             CALL       PGM(AB#RW1)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((Kaz.Watanabe@iafi.com)) +
                          DSTD('Check Orders...') MSG('** Note ** +
                          check ORDERS. (CHKC52).') +
                          DOCFILE(QTEMP/PRT198 ) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('CHECK ORDERS')
             DLTOVR     FILE(PRT198)
             ENDDO


             ENDPGM
