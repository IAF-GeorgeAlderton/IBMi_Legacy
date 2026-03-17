             PGM
             /** CHKC48 **********************************************/
             /*  PRINT HONDA ADJUSTED FULL BOX QTY REPORT            */
             /*  ADD CL TO AC#C2B                                    */
             /*  J.WATANABE  2019.03.20                              */
             /********************************************************/
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1 )
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             OVRPRTF    FILE(QPRINT) OUTQ(QPRINT) HOLD(*YES) SAVE(*YES)
             CALL       PGM(CHKR48) PARM(&RTN)

             IF         (&RTN *EQ '*') THEN(DO)
             CRTDUPOBJ  OBJ(PRT132B) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/PRT132B)
             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(QTEMP/PRT132B)
             CALL       PGM(AB#RW0)

 /* SEND MAIL */
             IF         COND((&USER *EQ 'I0777') *OR (USER *EQ +
                          'TEST')) THEN(DO)
             SNDDST     TYPE(*FILE) +
                          TOINTNET((Kaz.watanabe@iafi.com)) +
                          DSTD('HONDA ORDER FULL BOX QTY REPORT') +
                          MSG('HONDA ORDER QTY has been adjusted to +
                          be full box qty. (CHKC48).') +
                          DOCFILE(QTEMP/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('HONDA ORDER QTY +
                          ADJUSTMENT')
             DLTOVR     FILE(PRT132)
             DLTSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)
             ENDDO

             IF         COND((&USER *NE 'I0777') *AND (USER *NE +
                          'TEST')) THEN(DO)
             SNDDST     TYPE(*FILE) +
                          TOINTNET((ProductionControl@iafi.com)) +
                          DSTD('HONDA ORDER FULL BOX QTY REPORT') +
                          MSG('HONDA ORDER QTY has been adjusted to +
                          be full box qty. (CHKC48).') +
                          DOCFILE(QTEMP/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('HONDA ORDER QTY +
                          ADJUSTMENT')
             DLTOVR     FILE(PRT132)
             DLTSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)
             ENDDO

             ENDDO

             DLTOVR     FILE(QPRINT)

             ENDPGM
