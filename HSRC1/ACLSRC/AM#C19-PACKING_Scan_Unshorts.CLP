             PGM
             /** AM#C19 ************************/
             /* PACKING - SCAN UNSHORTS        */
             /*   LEC.             2020.09.14  */
             /**********************************/

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             DLTF       FILE(QTEMP/AM#WL19)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(QTEMP/AM#WP19)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AM#WP19) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)

             CRTDUPOBJ  OBJ(AM#WL19) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)

             OVRDBF     FILE(AM#WP19) TOFILE(QTEMP/AM#WP19)
             OVRDBF     FILE(AM#WL19) TOFILE(QTEMP/AM#WL19)

  /*  run program to scan short items and unshort them      */
             CALL       PGM(AM#R19)

  /*  print out UNshorts that were scanned into workfile      */
             OVRPRTF    FILE(QPRINT) PAGESIZE(80 198) LPI(8) CPI(15) +
                          OUTQ(SAVEOUTQ) HOLD(*YES)

             CALL       PGM(AM#R19P) PARM(&PRT)

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
                          DSTD('Toyota Shortage Reversal List') +
                          MSG('Toyota Shortage Reversal List') +
                          DOCFILE(QTEMP/PRT198) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('Toyota Shortage +
                          Reversal List')

             SNDDST     TYPE(*FILE) TOINTNET((APIC@iafi.com)) +
                          DSTD('Toyota Shortage Reversal List') +
                          MSG('Toyota Shortage Reversal List') +
                          DOCFILE(QTEMP/PRT198) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('Toyota Shortage +
                          Reversal List')

             SNDDST     TYPE(*FILE) +
                          TOINTNET((Jonathon.Julson@iafi.com)) +
                          DSTD('Toyota Shortage Reversal List') +
                          MSG('Toyota Shortage Reversal List') +
                          DOCFILE(QTEMP/PRT198) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('Toyota Shortage +
                          Reversal List')

  /*  print packing list for the Driver                        */
             CALL       PGM(AM#C19PL)

  /*  print packing list(s) for Shipping to resend the ASNs    */
             CALL       PGM(AM#R19PL)

             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)

  /*  print customs sheet if Toyota Canada (TMMC:3503) is in file.  */
             CALL       PGM(AB#C3S19)

             ENDDO

  /*  save workfile for just in case...                             */
            CPYF       FROMFILE(QTEMP/AM#WP19) +
                         TOFILE(HFILE1/AM#HP19) MBROPT(*ADD)
            MONMSG     MSGID(CPF0000)

 #END:       DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)

             ENDPGM
