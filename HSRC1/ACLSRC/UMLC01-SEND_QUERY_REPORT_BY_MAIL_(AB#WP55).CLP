             PGM
             /** UMLC01 ******************************************/
             /*  SEND QUERY REPORT BY MAIL (AB#WP55)             */
             /*  "HONDA AUTO ORDER PROCESS DATA"                 */
             /*  J.WATANABE  2019.0111                           */
             /****************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             RUNQRY     QRY(HOBJ1/WP55) OUTTYPE(*PRINTER)

             CPYSPLF    FILE(QPQUPRFIL) TOFILE(HWFILE1/PRT132DB) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132DB)
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((ProductionControl@iafi.com)) +
                          DSTD('HONDA AUTO PROCESS ORDER') +
                          MSG('HONDA AUTO PROCESS ORDER has been +
                          processed. Please check the attached +
                          report. (UMLC01).') +
                          DOCFILE(HWFILE1/PRT132) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('HONDA AUTO PROCESS') +
                          DOCDATE(*CURRENT) CRTDATE(*CURRENT) +
                          CMPDATE(*CURRENT) /* TCHK1 */
             DLTOVR     FILE(PRT132)
             DLTSPLF    FILE(QPQUPRFIL) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)

             ENDPGM
