             PGM

             DCL        VAR(&STAR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&KEN)  TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&RECS)  TYPE(*DEC)  LEN(10 0)

        /**  OVRDBF     FILE(AGDPP11) TOFILE(TFILE1/A@DPP11)  **/
        /**  OVRDBF     FILE(AGDPL11) TOFILE(TFILE1/A@DPL11)  **/
        /**  OVRDBF     FILE(AGDPL12) TOFILE(TFILE1/A@DPL12)  **/

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CLRPFM     FILE(TWFILE1/AB#WP0I)
             CLRPFM     FILE(TWFILE1/AB#WP90)
             MONMSG     MSGID(CPF0000)

/* JW1 2016.03.25 ADDED: SAVE AB#EP90/92/93       */
    /*TEST   CALL       PGM(EDSR30)   */

             OVRDBF     FILE(AB#EP90) TOFILE(TFILE1/AB#EP90)
             OVRDBF     FILE(AB#PP2A) TOFILE(TFILE1/AB#PP2A)
        /**  OVRDBF     FILE(AB#PP25) TOFILE(TFILE1/AB#PP25) **/
        /**  OVRDBF     FILE(AB#PL25) TOFILE(TFILE1/AB#PL25) **/
             OVRDBF     FILE(EDIPP45) TOFILE(TFILE1/EDIPP45)
             OVRDBF     FILE(AB#PP2I) TOFILE(TFILE1/AB#PP2I)
             OVRDBF     FILE(EDIPP42) TOFILE(TFILE1/EDIPP42)

             OVRDBF     FILE(AB#WP0I) TOFILE(TWFILE1/AB#WP0I)
             OVRDBF     FILE(AB#WP90) TOFILE(TWFILE1/AB#WP90)

             CALL       PGM(AB#R0I) PARM(&STAR)

             GOTO       CMDLBL(ENDP)

    /*TEST END ****************************************************** */
             IF         COND(&STAR *EQ '1') THEN(DO)

    /*TEST   SNDDST     TYPE(*LMSG) +                                 */
    /*TEST                TOINTNET((HondaEDIServiceParts@iafi.com)) + */
    /*TEST                DSTD('HONDA EDI(Star)') LONGMSG('We have +  */
    /*TEST                received EDI Service parts orders from +    */
    /*TEST                Honda. Please check the order +             */
    /*TEST                information. (AB#C0I)') DOCD('Honda EDI +   */
    /*TEST                Service Parts Order')                       */
             ENDDO

/* 850 DUPLICATE ERROR LIST */ /* TCHK4 START */
             RTVMBRD    FILE(TWFILE1/AB#WP0I) NBRCURRCD(&KEN)
             IF         (&KEN *GT 0) THEN(DO)
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(SAVEOUTQ) FORMTYPE(K6H1) HOLD(*YES)

             CALL       PGM(AB#R0I2)

             CPYSPLF    FILE(QPRINT) TOFILE(TWFILE1/PRT132) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)

             CALL       PGM(AB#RW0)

/*jw2 change Dulicate --> Duplicate */
             SNDDST     TYPE(*FILE) +
                          TOINTNET((EDI850DuplicateDataHonda@iafi.com+
                          )) DSTD('HONDA EDI 850 Duplicate Order +
                          Data') MSG('HONDA EDI 850 Duplicate data +
                          found.  Please check the attached list. +
                          (AB#C0I)') DOCFILE(TWFILE1/PRT132) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('HONDA +
                          EDI 850 Duplicate Order Data')

             CPYF       FROMFILE(TWFILE1/AB#WP0I)  +
                          TOFILE(TWFILE1/AB#WP0IA) +
                          MBROPT(*ADD)

             ENDDO

/* if new ship to codes for Honda were found, call pgm to email list     */
             RTVMBRD    FILE(TWFILE1/AB#WP90) NBRCURRCD(&RECS)
             IF         (&RECS *GT 0) THEN(DO)
             CALL       PGM(AB#C1M)
             ENDDO

ENDP:
             DLTOVR     FILE(*ALL)

             ENDPGM
