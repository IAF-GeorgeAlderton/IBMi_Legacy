             PGM
             /** CHKC53 **********************************************/
             /*  CHECK HONDA ORDERS CREATED BEFORE AUTO PROCESS      */
             /*  ADD JOB TO AC#C2B                                   */
             /*  J.WATANABE 2019.06.21                               */
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
             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(HOBJ1/CHKR53) PARM(&TGT &TYPE &RTN)

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
                          DSTD('Check HONDA Orders Created Before +
                          10:00AM ') MSG('** Note ** check HONDA +
                          ORDERS CREATED BEFORE 10:00AM (CHKC53).') +
                          DOCFILE(QTEMP/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('CHECK HONDA ORDERS +
                          CREATED BEFORE 10:00AM')
             DLTOVR     FILE(PRT132)
             ENDDO


             ENDPGM
