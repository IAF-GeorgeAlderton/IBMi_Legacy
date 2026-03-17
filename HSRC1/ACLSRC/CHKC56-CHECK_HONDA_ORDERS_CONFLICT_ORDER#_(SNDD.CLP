             PGM
             /** CHKC56 **********************************************/
             /*  CHECK HONDA ORDERS CINFLICT ORDER#                  */
             /*  ADD JOB TO AC#C2B                                   */
             /*  J.WATANABE 2019.07.01                               */
             /********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&SRC ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&SIGN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DAYS) TYPE(*CHAR) LEN(4)
             DCL        VAR(&IAF)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&TGT ) TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

/* CHECK TODAY'S SHIPMENT ----------------------------------------------*/
             CHGVAR     VAR(&SRC ) VALUE(' ')
             CALL       PGM(UTLR01) PARM(&SRC &DATE &RTN)

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(HOBJ1/CHKR56) PARM(&DATE &RTN)

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
                          DSTD('Check HONDA ORDER# CONFLICT') +
                          MSG('** Note ** check HONDA ORDER# +
                          CONFLIST. (CHKC56).') +
                          DOCFILE(QTEMP/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('CHECK HONDA ORDER# +
                          CONFLICT')
             DLTOVR     FILE(PRT132)
             ENDDO

/* GET 1 WORKING DAY AHEAD ---------------------------------------------*/
             CHGVAR     VAR(&SIGN) VALUE('+')
             CHGVAR     VAR(&DAYS) VALUE('0001')
             CHGVAR     VAR(&IAF ) VALUE('Y')
             CALL       PGM(UTLR10) PARM(&DATE &SIGN &DAYS &IAF &TGT &RTN)


             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(HOBJ1/CHKR56) PARM(&TGT &RTN)

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
                          DSTD('Check HONDA ORDER# CONFLICT') +
                          MSG('** Note ** check HONDA ORDER# +
                          CONFLIST. (CHKC56).') +
                          DOCFILE(QTEMP/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('CHECK HONDA ORDER# +
                          CONFLICT')
             DLTOVR     FILE(PRT132)
             ENDDO
/*----------------------------------------------------------------------*/


             ENDPGM
