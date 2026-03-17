             PGM
             /** AB#C0I3 *********************************************/
             /*  CHECK & FIX HONDA DUPLICATE ORDER                   */
             /*  ADD JOB TO AB#C0I                                   */
             /*  J.WATANABE 6/11/2020                                */
             /********************************************************/
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

/* CHECK DUPLICATE ORDERS (AB#PP2A) */

             OVRPRTF    FILE(QPRINT) PAGESIZE(80 198) LPI(8) CPI(15) +
                          OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(AB#R0I3) PARM('N' &RTN)

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
                          DSTD('** ERROR ** HONDA ORDER COMBINED') +
                          MSG('** ORDER DUPLICATE ERROR ** HONDA +
                          ORDER has combined in AB#PP2A! Please +
                          check attached report. (AB#C0I3N).') +
                          DOCFILE(QTEMP/PRT198) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('** ERROR ** HONDA +
                          ORDER COMBINED (PP2A)')
             DLTOVR     FILE(PRT198)
             ENDDO

             DLTOVR     FILE(QPRINT)

             ENDPGM
