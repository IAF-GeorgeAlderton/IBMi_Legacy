             PGM
             /** CHKC23 **********************************************/
             /*  CHECK INCORRECT UNIT PRICE                          */
             /*  ADD JOB TO VJBC71  (JOB SCHEDULE:  5:45 AM)         */
             /*  ADD JOB TO FCKC00  (JOB SCHEDULE: 10:10 AM)         */
             /*  ADD JOB TO VJBC72  (JOB SCHEDULE: 16:30 PM)         */
             /*                                                      */
             /*  J.WATANABE 10/13/2017                               */
             /********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN3) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN4) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN5) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

/* 1. INCORRECT U/P : (EXP=99 BUT NOT LAST) ============================*/
             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(HOBJ1/FBCR61F) PARM(' ' &RTN1)
             IF         (&RTN1 *EQ ' ') THEN(GOTO SKIP2)
    /*JW*/
             CALL       PGM(HOBJ1/FBCR61L) PARM('Y' ' ')
             CALL       PGM(HOBJ1/FBCR61F) PARM(' ' &RTN2)

             IF         (&RTN2 *EQ '*') THEN(DO)
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
                          DSTD('*** Incorrect Unit Price List ***') +
                          MSG('*** Incorrect Price(EXP=99 but not +
                          Last)*** Please fix it to prevent from +
                          Invoicing issue. (CHKC23-1).') +
                          DOCFILE(QTEMP/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('*** INCORRECT UNIT +
                          PRICE LIST ***')
             DLTOVR     FILE(PRT132)
             ENDDO
/* ENDDO ============================================================*/

/* 2. INCORRECT U/P : (DUPLICATE KEY) ==================================*/
SKIP2:
             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(HOBJ1/FBCR61I)     PARM('N')
             CALL       PGM(HOBJ1/FBCR61K)     PARM(' ' &RTN3)

             IF         (&RTN3 *EQ '*') THEN(DO)
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
                          DSTD('*** Incorrect Unit Price List ***') +
                          MSG('*** Incorrect Price(Duplicate) *** +
                          Please fix it to prevent from Invoicing +
                          issue. (CHKC23-2).') +
                          DOCFILE(QTEMP/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('*** INCORRECT UNIT +
                          PRICE LIST ***')
             DLTOVR     FILE(PRT132)
             ENDDO
/* ENDDO ============================================================*/

/* 3. INCORRECT U/P : (INCORRECT EXP DATE) =============================*/
SKIP3:
             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(HOBJ1/FBCR61 )     PARM('N' $RTN4)
             IF         (&RTN4 *EQ ' ') THEN(GOTO SKIPX)

             CALL       PGM(HOBJ1/FBCR61D)     PARM(' ' &RTN5)
             IF         (&RTN5 *NE ' ') THEN(DO)
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
                          DSTD('*** Incorrect Unit Price List ***') +
                          MSG('*** Incorrect Price(Exp_date) *** +
                          Please fix it to prevent from Invoicing +
                          issue. (CHKC23-3).') +
                          DOCFILE(QTEMP/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('*** INCORRECT UNIT +
                          PRICE LIST ***')
             DLTOVR     FILE(PRT132)
             ENDDO
 SKIPX:
/* ENDDO ============================================================*/
             ENDPGM
