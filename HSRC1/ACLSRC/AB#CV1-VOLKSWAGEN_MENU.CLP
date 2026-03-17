  PGM
/** AB#CV1 *************************************************/
/*  VOLKSWAGEN MENU                                        */
/* T.SAKAKI 11/17/15                                       */
/* J.WATA   2021.02.25 ADD ABVR76A FOR OPTION 7            */
/* JW2      2021.03.20 CHG ABVC2C --> ABVC2D               */
/************************************** AB#CV1 *************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             DCLF       FILE(AB#PWV1)
             RTVJOBA    JOB(&WSID) USER(&USR)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(ALBC01) PARM(&USR &PLIB &WLIB)

 STRT:
             CHGVAR     VAR(&#PGM) VALUE('AB#CV1')
             CHGVAR     VAR(&D@SLCT) VALUE('00')
             SNDRCVF    RCDFMT(DSP01)

             IF         (&IN01 *EQ '1') GOTO END

  /* ORDER RECEIVING HISTORY VIA EDI */
             IF         COND(&D@SLCT *EQ 1) THEN(CALL PGM(ABVCE1))

  /* VW LABEL DATA CREATE */
      /***   IF         COND(&D@SLCT *EQ 2) THEN(CALL PGM(ABVC2C)) **/
/*JW2*/      IF         COND(&D@SLCT *EQ 2) THEN(CALL PGM(ABVC2D))

  /* CASE LABEL SCAN RESULT INQUIRY */
       /*    IF         COND(&D@SLCT *EQ 3) THEN(CALL PGM(ABVC76))  */

  /* CASE LABEL SCAN BY MANUAL INPUT */
             IF         COND(&D@SLCT *EQ 4) THEN(CALL PGM(ABVC75))

  /* CREATE VW ASN */
             IF         COND(&D@SLCT *EQ 5) THEN(CALL PGM(ABVC0F))

  /* CHECK VW ASN DATA */
             IF         COND(&D@SLCT *EQ 6) THEN(CALL PGM(ABVCF5))

  /* VW CASE LABEL SCAN RESULT INQUIRY */
             IF         COND(&D@SLCT *EQ 7) THEN(CALL PGM(ABVR76A))

  /* VW SHIPPING VERIFICATION INQUIRY */
             IF         COND(&D@SLCT *EQ 8) THEN(CALL PGM(ABVC76))

  /* VW CASE SCAN FROM-TO    */
             IF         COND(&D@SLCT *EQ 9) THEN(CALL PGM(ABVC77))

             GOTO       STRT
 END:
             ENDPGM
