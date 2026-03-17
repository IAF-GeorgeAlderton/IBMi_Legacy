             PGM
             /*** GDAC00 *****************************************/
             /* ASJ MATERIAL PROCESSING                           */
             /*        TCH   MAY/12/03                           */
             /***************************************** GDAC00 ***/
             DCLF       FILE(GDAPW00)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 @STRT:      CHGVAR     VAR(&D@OPT) VALUE(' ')

             SNDRCVF    RCDFMT(DSP01)
             IF         (&IN01 *EQ '1') GOTO @END

  /* ORDER ENTRY  */
             IF         COND(&D@OPT *EQ '1') THEN(CALL PGM(GDAC01))

  /* ORDER SUMMARY */
             IF         COND(&D@OPT *EQ '2') THEN(CALL PGM(GDAC10))

  /* ORDER CHANGE  */
             IF         COND(&D@OPT *EQ '3') THEN(CALL PGM(GDAR11))

  /* ISSUE ORDER SHEET  */
             IF         COND(&D@OPT *EQ '4') THEN(CALL PGM(GDAC12))

  /* RE-ISSUE ORDER SHEET  */
             IF         COND(&D@OPT *EQ '5') THEN(CALL PGM(GDAC16))

  /* CHANGE ORDER DATA     */
             IF         COND(&D@OPT *EQ '6') THEN(CALL PGM(GDLC25))



             GOTO       CMDLBL(@STRT)

 @END:       ENDPGM
