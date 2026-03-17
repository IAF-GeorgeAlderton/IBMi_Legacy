             PGM
             /** CHKC23B *********************************************/
             /*  PRINT "PART NOT FOUND IN COMMON PART MASTER"        */
             /*  ADD JOB TO VJBC71  (JOB SCHEDULE:  5:45 AM)         */
             /*             VJBC72  (JOB SCHEDULE: 16:30 PM)         */
             /*  J.WATANABE 1/28/2021                                */
             /********************************************************/
             DCL        VAR(&UPD)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&CNT)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CHGVAR     VAR(&UPD) VALUE('Y')

/* CHECK THE PART NOT FOUND IN COMMON PART MASTER PR****************/

             OVRPRTF    FILE(QPRINT) PAGESIZE(66 198) LPI(6) CPI(15) +
                          OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(CHKR23) PARM(' ' &UPD &CNT)

             IF         (&CNT *NE '0000') THEN(DO)
             DLTF       FILE(QTEMP/PRT198 )
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(PRT198 ) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/PRT198 )
             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT198 ) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT198) TOFILE(QTEMP/PRT198 )
             CALL       PGM(AB#RW1)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((ProductionControl@iafi.com) +
                          (SalesGroup@iafi.com)) DSTD('*** PART NOT +
                          FOUND IN COMMON MASTER ***') MSG('** +
                          COMMON MASTER ERROR ** Part Not Found IN +
                          COMMON MASTER. Please confirm the +
                          attached report and register the Part +
                          ASAP if it is necessary. (CHKC23B).') +
                          DOCFILE(QTEMP/PRT198 ) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('*** PART NOT FOUND +
                          IN COMMON PART MASTER ***')
             DLTOVR     FILE(PRT198)
             ENDDO

             DLTOVR     FILE(QPRINT)

             ENDPGM
