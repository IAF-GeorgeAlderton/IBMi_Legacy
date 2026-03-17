             PGM        PARM(&WORKER)
             /** ALDC29 ************************/
             /* PACKING - SERVICE PARTS SCAN   */
             /*           SHORTAGE REVERSAL    */
             /*   LEC.             2021.06.17  */
             /**********************************/

             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             DLTF       FILE(QTEMP/ALDWL29)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/ALDWP29)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ALDWP29) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)

             CRTDUPOBJ  OBJ(ALDWL29) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)

             OVRDBF     FILE(ALDWP29) TOFILE(QTEMP/ALDWP29)
             OVRDBF     FILE(ALDWL29) TOFILE(QTEMP/ALDWL29)

  /*  run program to scan shorted items and unshort them      */
             CALL       PGM(ALDR29) PARM(&WORKER &USER)

  /*  print out UNshorts that were scanned into workfile      */
             OVRPRTF    FILE(QPRINT) PAGESIZE(80 198) LPI(8) CPI(15) +
                          OUTQ(SAVEOUTQ) HOLD(*YES)

             CALL       PGM(ALDR29P) PARM(&PRT)

  /*  if at least 1 "unshort" was printed, create & send email*/
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
                          DSTD('Service parts Shortage Reversal List') +
                          MSG('Service parts Shortage Reversal List') +
                          DOCFILE(QTEMP/PRT198) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('Service parts Shortage +
                          Reversal List')

             SNDDST     TYPE(*FILE) TOINTNET((APIC@iafi.com)) +
                          DSTD('Service parts Shortage Reversal List') +
                          MSG('Service parts Shortage Reversal List') +
                          DOCFILE(QTEMP/PRT198) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('Service parts Shortage +
                          Reversal List')

             SNDDST     TYPE(*FILE) +
                          TOINTNET((Jonathon.Julson@iafi.com)) +
                          DSTD('Service parts Shortage Reversal List') +
                          MSG('Service parts Shortage Reversal List') +
                          DOCFILE(QTEMP/PRT198) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('Service parts Shortage +
                          Reversal List')

  /*                                                           */
  /*  print packing list(s) for containers that were UNshorted */
  /*         CALL       PGM(ALDC29PL)                          */
  /*                                                           */

             ENDDO

 #END:       DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)

             ENDPGM
