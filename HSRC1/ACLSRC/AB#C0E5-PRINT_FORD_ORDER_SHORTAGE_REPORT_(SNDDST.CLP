             PGM
             /** AB#C0E5 *********************************************/
             /*  PRINT "FORD ORDER SHORTAGE REPORT"                  */
             /*  ADD JOB TO FCKC03  (JOB SCHEDULE:  7:33 AM)         */
             /*  J.WATANABE 2022.02.15                               */
             /********************************************************/
             DCL        VAR(&UPD)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&CNT)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CHGVAR     VAR(&UPD) VALUE('Y')

             OVRPRTF    FILE(QPRINT) LPI(6) CPI(10) OUTQ(SAVEOUTQ) +
                          HOLD(*YES)
             CALL       PGM(AB#R0E5) PARM(&RTN)

             IF         (&RTN *EQ '*') THEN(DO)
             DLTF       FILE(QTEMP/PRT132B)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(PRT132B) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/PRT132B)
             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132 ) TOFILE(QTEMP/PRT132B)
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((ProductionControl@iafi.com)) +
                          DSTD('** FORD ORDER SHORTAGE REPORT **') +
                          MSG('** NOTICE ** FORD ORDER HAS +
                          SHORTAGE. PLEASE CONFIRM THE ATTACHED +
                          REPORT. (AB#C0E5).') +
                          DOCFILE(QTEMP/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('** FORD ORDER +
                          SHORTAGE REPORT **')
             DLTOVR     FILE(PRT132)
             ENDDO

             DLTOVR     FILE(QPRINT)

             ENDPGM
