             PGM
/** AB#C0I ************************************************/
/*  HONDA 862 DATA                                        */
/*    H.AMANO       FEB/17/04                             */
/*                                                        */
/* TCHK1 : 12/05/05 CHG DST-NAME                          */
/* TCHK2 : 02/19/07 CHG DST-NAME                          */
/* TCHK3 : 06/25/08 CHG DST-NAME                          */
/* TCHK4 : 07/31/08 ADD 850 DUPLICATE CHECK               */
/* TCHK5 : 06/12/09 ADD TEMPORARY CHANGE CALENDAR M/F     */
/* JW1   : 2016.03.22 ADD: SAVE AB#EP90/92/93             */
/* JW2   : 2016.09.19 CHG: SPELLING                       */
/* JW3   : 2018.07.23 ADD: AB#C0I TO MSG                  */
/* JW4   : 2020.06.15 ADD: CHECK DUPLICATE ORDER          */
/* JW5   : 2025.03.27 ADD: UNIVAERSAL EDI ORDER           */
/**********************************************************/
             DCL        VAR(&STAR) TYPE(*CHAR) LEN(1)
/* TCHK4 */  DCL        VAR(&KEN)  TYPE(*DEC)  LEN(10 0)
/* TCHK4 */  DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
/* TCHK4 */  DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
/* TCHK4 */  DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&RECS)  TYPE(*DEC)  LEN(10 0)

/* TCHK5 */  OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
/* TCHK5 */  OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
/* TCHK5 */  OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

/* TCHK4 */  RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

/* TCHK4 */  CLRPFM     FILE(HWFILE1/AB#WP0I)
             CLRPFM     FILE(HWFILE1/AB#WP90)
             MONMSG     MSGID(CPF0000)

/* JW1 2016.03.25 ADDED: SAVE AB#EP90/92/93       */
             CALL       PGM(EDSR30)

             CALL       PGM(AB#R0I) PARM(&STAR)

             IF         COND(&STAR *EQ '1') THEN(DO)

/* TCHK1 S */
/* TCHK3 */
             SNDDST     TYPE(*LMSG) +
                          TOINTNET((HondaEDIServiceParts@iafi.com)) +
                          DSTD('HONDA EDI(Star)') LONGMSG('We have +
                          received EDI Service parts orders from +
                          Honda. Please check the order +
                          information. (AB#C0I)') DOCD('Honda EDI +
                          Service Parts Order')
             ENDDO

/* 850 DUPLICATE ERROR LIST */ /* TCHK4 START */
             RTVMBRD    FILE(HWFILE1/AB#WP0I) NBRCURRCD(&KEN)
             IF         (&KEN *GT 0) THEN(DO)
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(SAVEOUTQ) FORMTYPE(K6H1) HOLD(*YES)

             CALL       PGM(AB#R0I2)

             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)

             CALL       PGM(AB#RW0)

/*jw2 change Dulicate --> Duplicate */
             SNDDST     TYPE(*FILE) +
                          TOINTNET((EDI850DuplicateDataHonda@iafi.com+
                          )) DSTD('HONDA EDI 850 Duplicate Order +
                          Data') MSG('HONDA EDI 850 Duplicate data +
                          found.  Please check the attached list. +
                          (AB#C0I)') DOCFILE(HWFILE1/PRT132) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('HONDA +
                          EDI 850 Duplicate Order Data')

             CPYF       FROMFILE(HWFILE1/AB#WP0I)  +
                          TOFILE(HWFILE1/AB#WP0IA) +
                          MBROPT(*ADD)

             ENDDO

/* if new ship to codes for Honda were found, call pgm to email list     */
             RTVMBRD    FILE(HWFILE1/AB#WP90) NBRCURRCD(&RECS)
             IF         (&RECS *GT 0) THEN(DO)
             CALL       PGM(AB#C1M)
             ENDDO

             DLTOVR     FILE(*ALL)
/* TCHK4 END */

/*JW4 CHECK DUPLICATE ORDERS */
     /**     CALL       PGM(AB#C0I3Y)     STOP TEMP JW **/

/* JW5 2025.03.27 ADDED: UNIVAERSAL EDI ORDER     */
             CALL       PGM(AB#C12H)

             ENDPGM
