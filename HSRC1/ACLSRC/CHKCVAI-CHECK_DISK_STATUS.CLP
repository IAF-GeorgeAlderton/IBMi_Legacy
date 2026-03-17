             PGM
             /** CHKCVAI **********************************************/
             /*  CHECK DISK STATUS                                    */
             /*  ADD TO VJBC71 (RUN AT 5:45AM EVERY MORNING)          */
             /*  JW     2023.05.22                                    */
             /*********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             WRKDSKSTS  OUTPUT(*PRINT)

             CRTDUPOBJ  OBJ(PRT198) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/PRT198 )
             CPYSPLF    FILE(QPWCDSKS) TOFILE(QTEMP/PRT198) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT198) TOFILE(QTEMP/PRT198 )
             CALL       PGM(AB#RW1)

             SNDDST     TYPE(*FILE) +
                          TOINTNET(('KAZ.WATANABE@iafi.com')) +
                          DSTD('** DAILY DISK STATUS **') MSG('** +
                          AS400 DISK STATUS ** (CHKCVAI).') +
                          DOCFILE(QTEMP/PRT198) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('AS400 DISK STATUS')
             ENDPGM
