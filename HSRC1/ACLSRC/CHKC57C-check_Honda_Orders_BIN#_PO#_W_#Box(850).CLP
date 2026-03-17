             PGM
             /** CHKC57C *********************************************/
             /*  CHECK HONDA ORDERS BIN#/PO# - W/#BOX(850)           */
             /*  ADD TO VJBC71 (SCHEDULED JOB AT 5:45AM)             */
             /*  ADD TO VJBC72 (SCHEDULED JOB AT 4:36PM)             */
             /*  J.WATANABE 2021.06.17                               */
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
             CALL       PGM(HOBJ1/CHKR57C) PARM(&RTN)

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
                          DSTD('Check HONDA (850) ORDERS CONTAINS +
                          MIXED PO#') MSG('** Honda Mix PO# ** +
                          check HONDA 850 ORDERS CONTAIN MIXED PO#. +
                          (CHKC57C).') DOCFILE(QTEMP/PRT132A) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('CHECK +
                          HONDA 850 ORDERS CONTAIN MIXED PO#')
             DLTOVR     FILE(PRT132)
             ENDDO

             ENDPGM
