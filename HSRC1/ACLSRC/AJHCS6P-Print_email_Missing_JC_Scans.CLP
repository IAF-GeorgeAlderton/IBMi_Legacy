             PGM
             /** AJHCS6P ***********************/
             /* PRINT, EMAIL MISSING JC SCANS  */
             /*   LEC.             2024.06.24  */
             /**********************************/

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)


  /*  print out shorts that were scanned into workfile      */
             OVRPRTF    FILE(QPRINT) PAGESIZE(80 132) LPI(8) CPI(15) +
                          OUTQ(SAVEOUTQ) HOLD(*YES)

             CALL       PGM(AJHRS6P) PARM(&PRT)

  /*  if at least 1 "short" was printed, create & send email*/
             IF         COND(&PRT *EQ 'Y') THEN(DO)

  /*  create file to send from spool file and add CR & LF  */
             DLTF       FILE(QTEMP/PRT132)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(PRT132) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)


             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT132 ) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)

             OVRDBF     FILE(PRT132) TOFILE(QTEMP/PRT132)
             CALL       PGM(AB#RW0)

  /*     email report file to recipients                    */
             SNDDST     TYPE(*FILE) +
                          TOINTNET((JCMISSCAN@iafi.com)) +
                          DSTD('JC Scans Missing from Upload') +
                          MSG('JC Scans Missing from Upload') +
                          DOCFILE(QTEMP/PRT132) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('JC Scans Missing +
                          from Upload')

             SNDDST     TYPE(*FILE) TOINTNET((Larry.Cox@iafi.com)) +
                          DSTD('JC Scans Missing from Upload') +
                          MSG('JC Scans Missing from Upload') +
                          DOCFILE(QTEMP/PRT132) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('JC Scans Missing +
                          from Upload')

             SNDDST     TYPE(*FILE) +
                          TOINTNET((JONATHON.JULSON@iafi.com)) +
                          DSTD('JC Scans Missing from Upload') +
                          MSG('JC Scans Missing from Upload') +
                          DOCFILE(QTEMP/PRT132) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('JC Scans Missing +
                          from Upload')


             ENDDO

             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)

 #END:       ENDPGM
