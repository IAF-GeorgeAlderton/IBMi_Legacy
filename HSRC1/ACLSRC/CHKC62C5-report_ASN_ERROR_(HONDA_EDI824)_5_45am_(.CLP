             PGM
             /** CHKC62C5 ********************************************/
             /*  REPORT ASN ERROR (HONDA EDI824)                     */
             /*  ADD TO VJBC71 (RUN 5:45AM)                          */
             /*  START DATE IS YESTERDAY                             */
             /*  J.WATANABE 2024.05.21                               */
             /********************************************************/

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&SRC ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

 /* GET YESTERDAY */
             CALL       PGM(UTLR02Y) PARM((&DATE))

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             OVRPRTF    FILE(QPRINT) PAGESIZE(66 198) LPI(6) +
                          OVRFLW(62) OUTQ(LANPRT03) HOLD(*YES)

             CALL       PGM(CHKR62C ) PARM(&DATE &RTN)

  /************************/
  /**        GOTO ENDP    */
  /************************/

             IF         COND(&RTN = '*') THEN(DO)
             CRTDUPOBJ  OBJ(PRT198 ) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/PRT198 )
             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT198 ) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT198) TOFILE(QTEMP/PRT198 )
             CALL       PGM(AB#RW1)

     /**     SNDDST     TYPE(*FILE) +                                 **/
     /**                  TOINTNET((ProductionControl@iafi.com) +     **/
     /**                  (SalesGroup@iafi.com) +                     **/
     /**                  (JONATHON.JULSON@IAFI.COM)) DSTD('HONDA +   **/
     /**                  REJECTED ASN FOLLOW UP') MSG('''** HONDA +  **/
     /**                  REJECTED ASN ** PLEASE FOLLOW UP . +        **/
     /**                  (CHKC62C).') DOCFILE(QTEMP/PRT198) +        **/
     /**                  DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD('HONDA +  **/
     /**                  FOLLOW UP ASN')                             **/

             SNDDST     TYPE(*FILE) +
                          TOINTNET((Kaz.Watanabe@iafi.com)) +
                          DSTD('HONDA REJECTED ASN FOLLOW UP') +
                          MSG('''** HONDA REJECTED ASN ** PLEASE +
                          FOLLOW UP . (CHKC62C).') +
                          DOCFILE(QTEMP/PRT198) DOCTYPE(*FFT) +
                          SNDFMT(*NOCHG) DOCD('HONDA FOLLOW UP ASN')
             DLTOVR     FILE(PRT198)
             ENDDO
 ENDP:
             DLTSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             MONMSG MSGID(CPF0000)

             ENDPGM
