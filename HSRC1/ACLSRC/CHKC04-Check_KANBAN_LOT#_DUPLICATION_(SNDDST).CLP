             PGM
             /** CHKC04 **********************************************/
             /*  CHECK KANBAN LOT# DUPLICATION                       */
             /*  ADD JOB TO VJBC71  (JOB SCHEDULE: 5:45 AM)          */
             /*  J.WATANABE 2023.10.10                               */
             /********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)

             CLRPFM     FILE(CHKWP04)

             CALL       PGM(CHKR04) PARM(&RTN)

             IF         (&RTN *NE ' ') THEN(DO)
             CRTDUPOBJ  OBJ(PRT132A) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/PRT132A)
             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(QTEMP/PRT132A)
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((Takanao.Kato2@iafi.com) +
                          (Kaz.Watanabe@iafi.com)) DSTD('KANBAN +
                          TEHAI# DUPULICATE CHECK') MSG('KANBAN +
                          TEHAI# DUPLICATE CHECK LIST (CHKC04).') +
                          DOCFILE(QTEMP/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('KANBAN TEHAI# +
                          DUPLICATE CHECK LIST')
             DLTOVR     FILE(PRT132)
             ENDDO

             ENDPGM
