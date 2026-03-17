             PGM
             /** UMLC02 ******************************************/
             /*  SEND QUERY REPORT BY MAIL (AB#EP90S)            */
             /*  "HONDA ORDER RECEIVED AFTER 9:00AM              */
             /*  J.WATANABE  2019.03.26                          */
             /****************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)
 /* DETAIL */
             RUNQRY     QRY(WATALIB/EP90SP1) OUTTYPE(*PRINTER)

             CPYSPLF    FILE(QPQUPRFIL) TOFILE(HWFILE1/PRT132DB) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132DB)
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((KAZ.WATANABE@iafi.com)) +
                          DSTD('1.HONDA ORDER RECEIVED AFTER 9:00 +
                          am') MSG('1.HONDA ORDER RECEIVED AFTER +
                          9:00 AM.(UMLC02).') +
                          DOCFILE(HWFILE1/PRT132) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('1.HONDA ORDER +
                          RECEIVED AFTER 9AM') DOCDATE(*CURRENT) +
                          CRTDATE(*CURRENT) CMPDATE(*CURRENT) /* +
                          TCHK1 */
             DLTOVR     FILE(PRT132)
             DLTSPLF    FILE(QPQUPRFIL) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)

 /* ERROR */
             RUNQRY     QRY(WATALIB/EP90SP2) OUTTYPE(*PRINTER)

             CPYSPLF    FILE(QPQUPRFIL) TOFILE(HWFILE1/PRT132DB) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132DB)
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((KAZ.WATANABE@iafi.com)) +
                          DSTD('2.HONDA ORDER RECEIVED AFTER 9:00 +
                          am') MSG('2.HONDA ORDER RECEIVED AFTER +
                          9:00 AM.(UMLC02).') +
                          DOCFILE(HWFILE1/PRT132) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('2.HONDA ORDER +
                          RECEIVED AFTER 9AM') DOCDATE(*CURRENT) +
                          CRTDATE(*CURRENT) CMPDATE(*CURRENT) /* +
                          TCHK1 */
             DLTOVR     FILE(PRT132)
             DLTSPLF    FILE(QPQUPRFIL) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)
             ENDPGM
