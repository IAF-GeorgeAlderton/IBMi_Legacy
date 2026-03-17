             PGM
/** GADC15 ************************************************/
/*  PRINT AND SEND SHIPMENT M/F UPDATE LOG (GADWP11)      */
/*  J.WATANABE     2018.10.08                             */
/**********************************************************/

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CNT) TYPE(*DEC) LEN(10 0)

             RTVMBRD    FILE(GADWP11) NBRCURRCD(&CNT)
             IF         COND(&CNT *EQ 0) THEN(DO)
             GOTO @ENDP
             ENDDO

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             OVRPRTF    FILE(QPRINT) OUTQ(QPRINT) SAVE(*YES)
             CALL       PGM(GADR13)

             IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132B)
             CALL       PGM(AB#RW0)

  /*JW TEST */
       /*    SNDDST     TYPE(*FILE) +                                   */
       /*                 TOINTNET((kaz.watanabe@IAFI.COM)) +           */
       /*                 DSTD('CUST/DELIVERY CODE/DOCK UPDATE +        */
       /*                 LOG') MSG('Customer/ship to/dock code has +   */
       /*                 been updated. Please check the attached +     */
       /*                 list. (GADC15).') +                           */
       /*                 DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +      */
       /*                 SNDFMT(*NOTE) DOCD('Cust/Ship to/Dock/ +      */
       /*                 update log')                                  */

             SNDDST     TYPE(*FILE) +
                          TOINTNET((kaz.watanabe@iafi.com)) +
                          DSTD('CUST/DELIVERY CODE/DOCK UPDATE +
                          LOG') MSG('Customer/ship to/dock code has +
                          been updated. Please check the attached +
                          list. (GADC15).') +
                          DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('Cust/Ship to/Dock/ +
                          update log')

             DLTOVR     FILE(PRT132)
         /*  DLTSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) +    */
         /*               SPLNBR(*LAST)                         */
         /*  MONMSG     MSGID(CPF0000)                          */
         /*  CPYF       FROMFILE(GADWP11) TOFILE(GADWP11SV) +   */
         /*               MBROPT(*REPLACE) CRTFILE(*NO)         */
         /*  CLRPFM     FILE(GADWP11)                           */

             ENDDO
@ENDP:
             ENDPGM
