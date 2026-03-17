             PGM
             /** EJKC51 ********************************/
             /*     B2B_S   SENDING PROGRAMS           */
             /*    **ORIGINAL IS JK501C FROM ASJ**     */
             /*  T.SAKAKI            2016.10.12        */
             /******************************************/
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SLIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JYKB) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DKBN) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SAKI) TYPE(*CHAR) LEN(10)
             DCL        VAR(&HFID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SFNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)

             DCL        VAR(&TCPFLG) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&PJBFLG) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&PMSG)   TYPE(*CHAR) LEN(512)
      /*     DCL        VAR(&PMSGQ) TYPE(*CHAR) LEN(10) +
                          VALUE('QSYSOPR   ')         */
             DCL        VAR(&PKINP)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PROG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERID)   TYPE(*CHAR)  LEN(2)
             DCL        VAR(&COUT)   TYPE(*DEC)  LEN(3)

 STP1:
             CHGVAR     VAR(&ERID) VALUE('  ')
     /*-------------------------------*/
     /* PULL OUT UNPROCESSED EDI DATA */
     /*-------------------------------*/
             CALL       PGM(EJKR53) PARM(&JYKB &LIBL &FILE &DKBN +
                          &SAKI &SLIBL &SFILE &HFID &SFNM)
             IF         COND(&FILE *EQ '          ') THEN(GOTO +
                          CMDLBL(@END))

     /*-------------------*/
     /*  PRESENCE CHECK   */
     /*-------------------*/
             CHKOBJ     OBJ(&LIBL/&FILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CHGVAR     VAR(&PMSG) VALUE('SENDING FILE *' *TCAT +
                          &LIBL *TCAT '/' *TCAT &FILE *TCAT '* DOES +
                          NOT EXIST. PLEASE SEE EJKPP50 FOR MORE +
                          DETAIL.')
             CHGVAR     VAR(&PKINP) VALUE('G    ')
             CHGVAR     VAR(&PKOUT) VALUE(' ')
     /* STOP MESSAGE  */
     /*      CALL       PGM(APLC50) PARM(&PMSG &PKINP &PMSGQ &PKOUT) */
             CALL       PGM(EJKR54) PARM(&JYKB &LIBL &FILE &DKBN +
                          &SAKI '01')
             GOTO       CMDLBL(STP1)
             ENDDO

     /*-------------------*/
     /*  CONTENT CHECK    */
     /*-------------------*/
             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(&LIBL/&FILE) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&PMSG) VALUE('SENDING FILE *' *TCAT +
                          &LIBL *TCAT '/' *TCAT &FILE *TCAT '* HAS +
                          NO RECORD. PLEASE SEE EJKPP50 FOR MORE +
                          DETAIL.')
             CHGVAR     VAR(&PKINP) VALUE('G    ')
             CHGVAR     VAR(&PKOUT) VALUE(' ')
     /* STOP MESSAGE  */
     /*      CALL       PGM(APLC50) PARM(&PMSG &PKINP &PMSGQ &PKOUT) */
     /* SET ERROR DATE */
             CALL       PGM(EJKR54) PARM(&JYKB &LIBL &FILE &DKBN +
                          &SAKI '02')
             GOTO       CMDLBL(STP1)
             ENDDO

     /*--------------------------------*/
     /* CHECK CONNECTION TO B2B SERVER */
     /*--------------------------------*/
     /* IF NO SERVER NAME */
             IF         COND(&SAKI *EQ '          ') THEN(DO)
             CALL       PGM(EJKR54) PARM(&JYKB &LIBL &FILE &DKBN +
                          &SAKI '03')
             GOTO       CMDLBL(STP1)
             ENDDO

             CALL       PGM(APLC45) PARM(&SAKI &TCPFLG)

             IF         COND(&TCPFLG *EQ '1') THEN(DO)
     /* SET ERROR DATE */
             CALL       PGM(EJKR54) PARM(&JYKB &LIBL &FILE &DKBN +
                          &SAKI '03')
             GOTO       CMDLBL(STP1)
             ENDDO

     /*-----------------------------------*/
     /* CHECK PREVIOUS JOB IS DONE OR NOT */
     /*-----------------------------------*/
             CHGVAR     VAR(&COUT) VALUE(60)
             CALL       PGM(EJKC70) PARM(&HFID &COUT &PJBFLG)

             IF         COND(&PJBFLG *EQ '2') THEN(DO)
     /* SET ERROR DATE */
             CALL       PGM(EJKR54) PARM(&JYKB &LIBL &FILE &DKBN +
                          &SAKI '05')
             GOTO       CMDLBL(STP1)
             ENDDO

     /*-----------------------*/
     /*  SET STARTING DATE    */
     /*-----------------------*/
             CALL       PGM(EJKR56) PARM(&JYKB &LIBL &FILE &DKBN &SAKI)

     /*-----------------------*/
     /*  SENDING PROGRAM      */
     /*-----------------------*/
             CALL       PGM(EJKC64) PARM(&LIBL &FILE &SLIBL &SFILE +
                          &SAKI &HFID &SFNM)

     /*-----------------------*/
     /*  SET COMPLETE DATE    */
     /*-----------------------*/
             CALL       PGM(EJKR52) PARM(&JYKB &LIBL &FILE &DKBN &SAKI)

 @END:
             ENDPGM
