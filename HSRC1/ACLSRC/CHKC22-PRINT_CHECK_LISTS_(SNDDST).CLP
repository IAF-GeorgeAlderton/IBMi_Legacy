             PGM
             /** CHKC22 **********************************************/
             /*  PRINT CHECK LISTS                                   */
             /*  ADD JOB TO FCKC00  (JOB SCHEDULE: 10:10 AM)         */
             /*    1. INCORRECT IAF PART (COMMON)  LIST              */
             /*    2. INCORRECT UNIT PRICE LIST                      */
             /*    3. INCORRECT ORDER LIST (PP10 VS PPA1)            */
             /*                                                      */
             /*  J.WATANABE 5/2/2016                                 */
             /********************************************************/
             DCL        VAR(&CNT)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

/* CHECK INCORRECT COMMON PART *********************************/

             OVRPRTF    FILE(QPRINT) PAGESIZE(80 198) LPI(8) CPI(15) +
                          OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(CHKR22) PARM(&CNT 'Y')

             IF         (&CNT *NE '0000') THEN(DO)
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
                          DSTD('*** Incorrect Common Part List +
                          ***') MSG('*** Incorrect IAF Parts has +
                          been found in Order Data *** Please fix +
                          it to prevent from ASN issue. (CHKC22).') +
                          DOCFILE(QTEMP/PRT198) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('*** INCORRECT IAF +
                          PART IN ORDER (COMMON) ***')
             DLTOVR     FILE(PRT198)
             ENDDO

             DLTOVR     FILE(QPRINT)

             ENDPGM
