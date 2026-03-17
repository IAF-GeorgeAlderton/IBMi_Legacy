             PGM        PARM(&SHDT)

             /** AB#C432  ****************************************/
             /* PRINT SCS OPEN PO COMPARISON   - TO BE EMAILED   */
             /*   LEC.             2022.08.17                    */
             /****************************************************/

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SHDT) TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

  /*  print out order comparison listing ...                  */
             OVRPRTF    FILE(QPRINT) PAGESIZE(80 198) LPI(8) CPI(15)

             CALL       PGM(AB#R432) PARM(&SHDT)

  /*  create file to send from spool file and add CR & LF  */
             DLTF       FILE(QTEMP/PRT198)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(PRT198) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)

             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT198 ) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)

             OVRDBF     FILE(PRT198) TOFILE(QTEMP/PRT198)
             CALL       PGM(AB#RW1)

  /*  send email to distribution list...                             */

             SNDDST     TYPE(*FILE) TOINTNET((Larry.Cox@iafi.com)) +
                          DSTD('Compare IAF Order File vs SCS Open +
                          PO File') MSG('Compare IAF Order File vs +
                          SCS Open PO File') DOCFILE(QTEMP/PRT198) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) +
                          DOCD('Compare IAF Order File vs SCS Open +
                          PO File')

             SNDDST     TYPE(*FILE) +
                          TOINTNET((Jonathon.Julson@iafi.com)) +
                          DSTD('Compare IAF Order File vs SCS Open +
                          PO File') MSG('Compare IAF Order File vs +
                          SCS Open PO File') DOCFILE(QTEMP/PRT198) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) +
                          DOCD('Compare IAF Order File vs SCS Open +
                          PO File')

             SNDDST     TYPE(*FILE) +
                          TOINTNET((Rebecca.Gregory@iafi.com)) +
                          DSTD('Compare IAF Order File vs SCS Open +
                          PO File') MSG('Compare IAF Order File vs +
                          SCS Open PO File') DOCFILE(QTEMP/PRT198) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) +
                          DOCD('Compare IAF Order File vs SCS Open +
                          PO File')

             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)

 #END:       ENDPGM
