             PGM
             /** CHKC57 **********************************************/
             /*  CHECK HONDA ORDERS CONFLICT PLANT/SHIP CODE         */
             /*  ADD JOB TO AC#C2B                                   */
             /*  J.WATANABE 2019.07.03                               */
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

             CHGVAR     VAR(&SRC ) VALUE(' ')
             CALL       PGM(UTLR01) PARM(&SRC &DATE &RTN)

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(HOBJ1/CHKR57) PARM(&DATE &RTN)

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
                          DSTD('Check HONDA PLANT/SHIP TO +
                          CONFLICT') MSG('** Note ** check HONDA +
                          PLANT/SHIPTO CONFLIST. (CHKC56).') +
                          DOCFILE(QTEMP/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('CHECK HONDA +
                          PLANT/SHIPTO CONFLICT')
             DLTOVR     FILE(PRT132)
             ENDDO

             ENDPGM
