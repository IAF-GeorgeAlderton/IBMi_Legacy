             PGM
             /** CHKC41 **********************************************/
             /*  CHECK HONDA SHIP CODE IN AB#PP2A                    */
             /*  ADD JOB TO FCKC00  (JOB SCHEDULE: 10:10 AM)         */
             /*  J.WATANABE 6/12/2019                                */
             /********************************************************/
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

/* CHECK DUPLICATE ORDERS (AB#PP10) */

             OVRPRTF    FILE(QPRINT) PAGESIZE(80 198) LPI(8) CPI(15) +
                          OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(CHKR41) PARM(&RTN)

             IF         (&RTN *EQ '*') THEN(DO)
             CRTDUPOBJ  OBJ(PRT198 ) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/PRT198 )
             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT198 ) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT198) TOFILE(QTEMP/PRT198 )
             CALL       PGM(AB#RW1)

             SNDDST     TYPE(*FILE) +
                          TOINTNET((Kaz.Watanabe@iafi.com)) +
                          DSTD('** ERROR ** HONDA ORDER +
                          PLANT/SHIPTO ERROR') MSG('** PLANT/SHIPTO +
                          ERROR ** HONDA ORDER has error in +
                          AB#PP2A! Please check attached report. +
                          (CHKC41).') DOCFILE(QTEMP/PRT198) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('** +
                          ERROR ** HONDA PLANT/SHIPTO (PP2A)')
             DLTOVR     FILE(PRT198)
             ENDDO

             DLTOVR     FILE(QPRINT)

             ENDPGM
