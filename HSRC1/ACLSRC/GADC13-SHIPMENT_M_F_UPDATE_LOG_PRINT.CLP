             PGM
/** GADC13 ************************************************/
/*  SHIPMENT M/F UPDATE LOG                               */
/*  ** GENTRAN IS USING THIS CL EVERY 15 MINUTES **       */
/*  I-HASADA                   97.01.22                   */
/*                                                        */
/* TCHK1 02/15/12 CHG E-MAIL DESTNATION                   */
/* TCHK2 02/24/15 CHG E-MAIL DESTNATION                   */
/* JW1   06/22/16 CHG E-MAIL DESTNATION                   */
/**********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CNT) TYPE(*DEC) LEN(10 0)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGJOB     SWS(00000000)
             OVRPRTF    FILE(QPRINT) OUTQ(QPRINT) SAVE(*YES)

             CALL       PGM(GADR13)

             CPYF       FROMFILE(&WLIB/GADWP11) +
                          TOFILE(QTEMP/GADWP11BK) MBROPT(*REPLACE) +
                          CRTFILE(*YES) INCREL((*IF WWPRNT *EQ ' '))
             MONMSG     MSGID(CPF0000)

             RTVMBRD    FILE(GADWP11BK) NBRCURRCD(&CNT)
             IF         COND(&CNT *EQ 0) THEN(DO)
             CLRPFM GADWP11
             MONMSG     MSGID(CPF0000)
             GOTO @SKIP
             ENDDO

             CPYF       FROMFILE(QTEMP/GADWP11BK) +
                          TOFILE(&WLIB/GADWP11) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)
    @SKIP:
             DLTOVR     FILE(*ALL)

             IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)

             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132B)
             CALL       PGM(AB#RW0)

/* JW1 */
             SNDDST     TYPE(*FILE) +
                          TOINTNET(                                    +
                                  (AS400_AC_ORDER_UPDATE_LOG@IAFI.COM) +
                                  (KAZ.WATANABE@IAFI.COM)              +
                                   )                                   +
                          DSTD('CUST/DELIVERY CODE/DOCK UPDATE +
                          LOG') MSG('Customer/ship to/dock code has +
                          been updated. Please check the attached +
                          list. (GADC13).') +
                          DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('Cust/Ship to/Dock/ +
                          update log')

             DLTOVR     FILE(PRT132)
             DLTSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)
             ENDDO

   /*JW      CALL       PGM(UTLR07) PARM('PRG: GADC13')    */

             ENDPGM
