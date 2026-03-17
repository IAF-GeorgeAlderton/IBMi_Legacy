  PGM
/** AB#CHM *************************************************/
/*  HONDA MAINTANANCE MENU                                 */
/*                                                         */
/* T.SAKAKI   10/12/2015                        %0001      */
/* J.WATANABE 03/31/2017  ADD OPT#10            JW1        */
/* J.WATANABE 06/29/2017  ADD OPT#20            JW2        */
/* J.WATANABE 02/21/2018  ADD OPT#03            JW3        */
/************************************** AB#CHN *************/
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCLF       FILE(AB#PWHM)

             RTVJOBA    JOB(&WSID) USER(&USR)
 STRT:
             CHGVAR     VAR(&D@SLCT) VALUE('00')
             SNDRCVF    RCDFMT(DSP01)
  /* END */
             IF         (&IN01 *EQ '1') GOTO END
             IF         (&IN03 *EQ '1') GOTO END
             IF         (&IN12 *EQ '1') GOTO END

  /* PRICE PLANT ID MASTER  832 */
             IF         COND(&D@SLCT *EQ 1) THEN(CALL PGM(AG#C01))

  /* PLANT, SHIP TO AND DELIVERY CODE TABLE */
             IF         COND(&D@SLCT *EQ 2) THEN(CALL PGM(AB#CH1))

  /* JW3 PPRINT HONDA ISOLATED PART LIST    */
             IF         COND(&D@SLCT *EQ 3) THEN(CALL PGM(FBCC51))

  /* JW1 CANCEL EDI(856) DATA BY ASN#       */
             IF         COND(&D@SLCT *EQ 10) THEN(CALL PGM(AC#C0Q))

  /* JW2 ADD HONDA EDI ORDER INQ            */
     /****** IF         COND(&D@SLCT *EQ 20) THEN(CALL PGM(AB#RH5)) ****/
             IF         COND(&D@SLCT *EQ 20) THEN(CALL PGM(AB#CH5C))

  /* JW3 ADD HONDA EDI ASN STATUS INQ       */
             IF         COND(&D@SLCT *EQ 21) THEN(CALL PGM(AB#RH7))

             GOTO       STRT
 END:
             ENDPGM
