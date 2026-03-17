             PGM
             /** CHKC73 **********************************************/
             /*  CPRINT SUBARU ADJUSTED FULL BOX QTY REPORT          */
             /*  ADD JOB TO AC#C2B                                   */
             /*  J.WATANABE 2019.07.24                               */
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

/* GET DATE 2 WEEKS AGO */
             CHGVAR     VAR(&SRC ) VALUE(' ')
             CALL       PGM(UTLR01) PARM(&SRC &DATE &RTN)

/* GET YESTERDAY */
             CHGVAR     VAR(&SIGN) VALUE('-')
             CHGVAR     VAR(&DAYS) VALUE('0014')
             CHGVAR     VAR(&IAF ) VALUE('N')
             CALL       PGM(UTLR10) PARM(&DATE &SIGN &DAYS &IAF &TGT &RTN)

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(HOBJ1/CHKR73) PARM(&TGT &RTN)

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
                          DSTD('Check SUBARU ORDER QTY (ADJUSTED)') +
                          MSG('** Note ** check SUBARU ORDER QTY +
                          (ADJUSTED). (CHKC73).') +
                          DOCFILE(QTEMP/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('CHECK SUBARU ORDER +
                          QTY (ADJUSTED)')
             DLTOVR     FILE(PRT132)
             ENDDO

 /* PRINT FOR PC */
             IF         COND((&USER *NE 'I0777') *AND (USER *NE +
                          'TEST')) THEN(DO)
             SNDDST     TYPE(*FILE) +
                          TOINTNET((ProductionControl@iafi.com)) +
                          DSTD('Check SUBARU ORDER QTY (ADJUSTED)') +
                          MSG('** Note ** check SUBARU ORDER QTY +
                          (ADJUSTED). (CHKC73).') +
                          DOCFILE(QTEMP/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('CHECK SUBARU ORDER +
                          QTY (ADJUSTED)')
             DLTOVR     FILE(PRT132)
             ENDDO

             ENDDO

             ENDPGM
