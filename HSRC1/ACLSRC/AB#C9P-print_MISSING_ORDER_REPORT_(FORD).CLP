/** AB#C9P ************************************************/
/*  PRINT FORD MISSING ORDER REPORT                       */
/*  J.WATANABE  2026.02.05                                */
/**********************************************************/
             PGM        PARM(&SDATE)

             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(AB#R9P) PARM(&SDATE &RTN)

             IF         (&RTN *NE ' ') THEN(DO)
             CRTDUPOBJ  OBJ(PRT132A) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/PRT132A)
             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(QTEMP/PRT132A)
             CALL       PGM(AB#RW0)

    /**      SNDDST     TYPE(*FILE) +                                  **/
    /**                   TOINTNET((PRODUCTIONCONTROL@IAFI.COM)) +     **/
    /**                   DSTD('(FORD) MISSING ORDER REPORT') +        **/
    /**                   MSG('FORD MISSING ORDER REPORT +             **/
    /**                   (AB#C9P).') DOCFILE(QTEMP/PRT132A) +         **/
    /**                   DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('FORD +    **/
    /**                   MISSING ORDER REPORT')                       **/

             SNDDST     TYPE(*FILE) +
                          TOINTNET((Kaz.Watanabe@iafi.com)) +
                          DSTD('(FORD) MISSING ORDER REPORT') +
                          MSG('FORD MISSING ORDER REPORT +
                          (AB#C9P).') DOCFILE(QTEMP/PRT132A) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('FORD +
                          MISSING ORDER REPORT')

             DLTOVR     FILE(*ALL)
             DLTSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)

             ENDDO

             ENDPGM
