             PGM
             /** AM#C17P ***********************/
             /* PACKING - PRINT SHORTAGES      */
             /*   LEC.             2019.08.23  */
             /**********************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PATH) TYPE(*CHAR) LEN(100)
             DCL        VAR(&DATTIM) TYPE(*CHAR) LEN(20)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             RTVSYSVAL  SYSVAL(QDATETIME) RTNVAR(&DATTIM)

             CHGVAR     VAR(&PATH) +
                          VALUE('/QNTC/IAF-AS400-FILE/AS400-TRANS/PC/+
                          DOWNLOAD/SSN/' *TCAT %SST(&DATTIM 1 8) +
                          *TCAT '_' *TCAT %SST(&DATTIM 9 6) *TCAT +
                          '.txt')

  /*  print out shorts that were scanned into workfile      */
             OVRPRTF    FILE(QPRINT) PAGESIZE(80 198) LPI(8) CPI(15) +
                          OUTQ(SAVEOUTQ) HOLD(*YES)

             CALL       PGM(AM#R17P) PARM(&PRT)

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
             SNDDST     TYPE(*FILE) TOINTNET((APIC@iafi.com)) +
                          DSTD('Toyota Shortage List') MSG('Toyota +
                          Shortage List') DOCFILE(QTEMP/PRT198) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('Toyota +
                          Shortage List')

             SNDDST     TYPE(*FILE) TOINTNET((PCSupport@iafi.com)) +
                          DSTD('Toyota Shortage List') MSG('Toyota +
                          Shortage List') DOCFILE(QTEMP/PRT198) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('Toyota +
                          Shortage List')

             SNDDST     TYPE(*FILE) TOINTNET((Shipping@iafi.com)) +
                          DSTD('Toyota Shortage List') MSG('Toyota +
                          Shortage List') DOCFILE(QTEMP/PRT198) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('Toyota +
                          Shortage List')

             SNDDST     TYPE(*FILE) TOINTNET((Larry.Cox@iafi.com)) +
                          DSTD('Toyota Shortage List') MSG('Toyota +
                          Shortage List') DOCFILE(QTEMP/PRT198) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('Toyota +
                          Shortage List')

             SNDDST     TYPE(*FILE) +
                          TOINTNET((Jonathon.Julson@iafi.com)) +
                          DSTD('Toyota Shortage List') MSG('Toyota +
                          Shortage List') DOCFILE(QTEMP/PRT198) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('Toyota +
                          Shortage List')

  /*  send file to short ship notification folder          */

      /* create empty file and copy to file path           */
             CRTDUPOBJ  OBJ(FILE1024) FROMLIB(HWFILE1) +
                          OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/FILE1024)
             MONMSG     MSGID(CPF0000)

             CPYTOIMPF  FROMFILE(QTEMP/FILE1024) TOSTMF(&PATH) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +
                          TIMFMT(*USA)
             MONMSG     MSGID(CPF2817)

   /* create text file from spool file and output overtop of empty file path */
             CPYF       FROMFILE(QTEMP/PRT198) +
                          TOFILE(QTEMP/FILE1024) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)

             CPYTOIMPF  FROMFILE(QTEMP/FILE1024) TOSTMF(&PATH) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          DTAFMT(*FIXED) RMVBLANK(*BOTH) +
                          FLDDLM(',') DATFMT(*USA) TIMFMT(*USA) +
                          ADDCOLNAM(*NONE)
             MONMSG     MSGID(CPF2817)


             ENDDO

             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)

 #END:       ENDPGM
