             PGM
             /** CHKC38E *********************************************/
             /*  CHECK DIFFERENT ORDER QTY FOR HONDA                 */
             /*  ADD JOB TO VJBC71  (JOB SCHEDULE  05:45 AM)         */
             /*  ADD JOB TO FCKC00  (JOB SCHEDULE: 10:10 AM)         */
             /*  J.WATANABE 2021.08.13                               */
             /********************************************************/
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&RTN) VALUE(' ')

/* CHECK DIFFERENT ORDER QTY FOR HONDA */

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES) +
                          USRDTA('ACNONY=0')
             CALL       PGM(CHKR38E) PARM(&RTN)

             IF         (&RTN *EQ '*') THEN(DO)
             DLTF       FILE(QTEMP/PRT132A)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ OBJ(PRT132A) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(QTEMP/PRT132A)
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((kaz.watanabe@iafi.com)) +
                          DSTD('** ERROR ** (HONDA) EDI ORDER QTY +
                          DIFFERENCE') MSG('** NOTE ** HONDA EDI +
                          ORDER CONTAINS DIFFERENT QTY. PLEASE +
                          CONFIRM THE ATTACHED REPORT. (CHKC38E).') +
                          DOCFILE(QTEMP/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('** NOTE ** EDI ORDER +
                          QTY DIFFERENCE')
             DLTOVR     FILE(PRT132)
             ENDDO

             DLTOVR     FILE(QPRINT)

             ENDPGM
