             PGM
             /** CHKC42A *********************************************/
             /*  DETECT UNIT PRICE ERROR IN PP10                     */
             /*  ADD JOB TO FCKC00  (JOB SCHEDULE: 10:10 AM)         */
             /*  J.WATANABE 2022.03.28                               */
             /********************************************************/
             DCL        VAR(&NOHZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&UPD)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CHGVAR     VAR(&NOHZ) VALUE(' ')
             CHGVAR     VAR(&UPD)  VALUE('Y')

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)

             CALL       PGM(CHKR42A) PARM(&NOHZ &UPD &RTN)

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
                          DSTD('** PP10 ERROR ** PRICE SHOULD BE +
                          0') MSG('** PP10 PRICE ERROR ** PRICE +
                          SHOULD BE 0 ! Please check attached +
                          report. (CHKC42A).') +
                          DOCFILE(QTEMP/PRT132) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('** PP10 ERROR ** +
                          PRICE SHOULD BE 0  (PP10)')
             DLTOVR     FILE(PRT132)
             ENDDO

             DLTOVR     FILE(QPRINT)

             ENDPGM
