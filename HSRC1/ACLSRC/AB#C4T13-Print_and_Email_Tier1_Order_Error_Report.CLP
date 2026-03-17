             PGM
             /** AB#C4T13 ***************************************************/
             /* PRINT TIER1 ORDER ERROR REPORT - TO BE EMAILED              */
             /*   LEC.             2021.12.06                               */
             /* -------------------------------------                       */
             /*   JW1   2023.05.12 CHG PROGRAM NAME FROM AB#RT1E TO AB#R4T1 */
             /***************************************************************/

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

  /*  print out order creation error listing...             */
             OVRPRTF    FILE(QPRINT) PAGESIZE(80 198) LPI(8) CPI(15) +
                          OUTQ(SAVEOUTQ) HOLD(*YES)

     /**JW1  CALL       PGM(AB#RT1E) PARM(&PRT)   *************/
             CALL       PGM(AB#R4T1) PARM(&PRT)

  /*  if at least 1 container was printed, create & send email*/
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

  /*  send email to distribution list...                             */

             SNDDST     TYPE(*FILE) TOINTNET((Amanda.Norman@iafi.com)) +
                          DSTD('Tier 1 Auto Order Creation Error +
                          Listing') MSG('Tier 1 Auto Order Creation +
                          Error Listing') DOCFILE(QTEMP/PRT198) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('Tier 1 +
                          Auto Order Creation Error Listing')

             SNDDST     TYPE(*FILE) TOINTNET((Larry.Cox@iafi.com)) +
                          DSTD('Tier 1 Auto Order Creation Error +
                          Listing') MSG('Tier 1 Auto Order Creation +
                          Error Listing') DOCFILE(QTEMP/PRT198) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('Tier 1 +
                          Auto Order Creation Error Listing')

             SNDDST     TYPE(*FILE) +
                          TOINTNET((Kaz.Watanabe@iafi.com)) +
                          DSTD('Tier 1 Auto Order Creation Error +
                          Listing') MSG('Tier 1 Auto Order Creation +
                          Error Listing') DOCFILE(QTEMP/PRT198) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('Tier 1 +
                          Auto Order Creation Error Listing')

             ENDDO

             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)

 #END:       ENDPGM
