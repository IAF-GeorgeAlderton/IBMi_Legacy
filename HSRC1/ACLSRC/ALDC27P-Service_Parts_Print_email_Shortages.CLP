             PGM
             /** ALDC27P ***********************/
             /* SERVICE PARTS - PRINT SHORTAGES*/
             /*   LEC.             2021.05.25  */
             /**********************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

  /*  print out shorts that were scanned into workfile      */
             OVRPRTF    FILE(QPRINT) PAGESIZE(80 198) LPI(8) CPI(15) +
                          OUTQ(SAVEOUTQ) HOLD(*YES)

             CALL       PGM(ALDR27P) PARM(&PRT)

  /*  if at least 1 "short" was printed, create & send email*/
             IF         COND(&PRT *EQ 'Y') THEN(DO)

  /*  create file to send from spool file and add CR & LF  */
             DLTF       FILE(QTEMP/PRT198)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(PRT198) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)


             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT198 ) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)

             OVRDBF     FILE(PRT198) TOFILE(QTEMP/PRT198)
             CALL       PGM(AB#RW1)

  /*     email report file to recipients                    */
             SNDDST     TYPE(*FILE) TOINTNET((Larry.Cox@iafi.com)) +
                          DSTD('Service Parts Shortage List') +
                          MSG('Service Parts Shortage List') +
                          DOCFILE(QTEMP/PRT198) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('Service Parts +
                          Shortage List')

             SNDDST     TYPE(*FILE) TOINTNET((APIC@iafi.com)) +
                          DSTD('Service Parts Shortage List') +
                          MSG('Service Parts Shortage List') +
                          DOCFILE(QTEMP/PRT198) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('Service Parts +
                          Shortage List')

             SNDDST     TYPE(*FILE) +
                          TOINTNET((Jonathon.Julson@iafi.com)) +
                          DSTD('Service Parts Shortage List') +
                          MSG('Service Parts Shortage List') +
                          DOCFILE(QTEMP/PRT198) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('Service Parts +
                          Shortage List')

             SNDDST     TYPE(*FILE) +
                          TOINTNET((Rebecca.Gregory@iafi.com)) +
                          DSTD('Service Parts Shortage List') +
                          MSG('Service Parts Shortage List') +
                          DOCFILE(QTEMP/PRT198) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('Service Parts +
                          Shortage List')

             ENDDO

             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)

 #END:       ENDPGM
