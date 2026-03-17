             PGM
             /** EJKC02 ********************************/
             /* B2B_R   RECEIVING PROGRAMS             */
             /*    **ORIGINAL IS JK101C FROM ASJ**     */
             /*  T.SAKAKI            2016.10.11        */
             /******************************************/
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JYKB) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DKBN) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SAKI) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ORGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PROG) TYPE(*CHAR) LEN(10)

             DCL        VAR(&PKINP)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&PMSG)   TYPE(*CHAR) LEN(512)
             DCL        VAR(&ERID)   TYPE(*CHAR)  LEN(2)
      /*     DCL        VAR(&PMSGQ) TYPE(*CHAR) LEN(10) +
                          VALUE('QSYSOPR   ')         */

 STP1:
             CHGVAR     VAR(&ERID) VALUE('  ')
     /*-------------------------------*/
     /* PULL OUT UNPROCESSED EDI DATA */
     /*-------------------------------*/
             CALL       PGM(EJKR09) PARM(&JYKB &LIBL &FILE &DKBN +
                          &ORGF &SAKI)
             IF         COND(&FILE *EQ '          ') THEN(GOTO +
                          CMDLBL(@END))

     /*-------------------*/
     /*  PRESENCE CHECK   */
     /*-------------------*/
             CHKOBJ     OBJ(&LIBL/&FILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CHGVAR     VAR(&PMSG) VALUE('RECEIVING FILE *' *TCAT +
                          &LIBL *TCAT '/' *TCAT &FILE *TCAT '*  +
                          DOES NOT EXIST. PLEASE CONTACT IT PERSON')
             CHGVAR     VAR(&PKINP) VALUE('G    ')
             CHGVAR     VAR(&PKOUT) VALUE(' ')
     /* STOP MESSAGE  */
     /*      CALL       PGM(APLC50) PARM(&PMSG &PKINP &PMSGQ &PKOUT) */
     /* SET ERROR DATE */
             CALL       PGM(EJKR14) PARM(&JYKB &LIBL &FILE &DKBN +
                          &SAKI '01')
             GOTO       CMDLBL(STP1)
             ENDDO

     /*-------------------*/
     /*  CONTENT CHECK    */
     /*-------------------*/
             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(&LIBL/&FILE) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&PMSG) VALUE('RECEIVING FILE *' *TCAT +
                          &LIBL *TCAT '/' *TCAT &FILE *TCAT '*  HAS +
                          NO RECORD. PLEASE CONTACT IT PERSON')
             CHGVAR     VAR(&PKINP) VALUE('G    ')
             CHGVAR     VAR(&PKOUT) VALUE(' ')
     /* STOP MESSAGE  */
     /*      CALL       PGM(APLC50) PARM(&PMSG &PKINP &PMSGQ &PKOUT) */
     /* SET ERROR DATE */
             CALL       PGM(EJKR14) PARM(&JYKB &LIBL &FILE &DKBN +
                          &SAKI '02')
             GOTO       CMDLBL(STP1)
             ENDDO

     /*----------------*/
     /*  GET PROGRAM   */
     /*----------------*/
             CALL       PGM(EJKR10) PARM(&JYKB 'R' &DKBN &PROG)

     /* IF NO DATA, SET ERROR DATE */
             IF         COND(&PROG *EQ '          ') THEN(DO)
     /* SET ERROR DATE */
             CALL       PGM(EJKR14) PARM(&JYKB &LIBL &FILE &DKBN +
                          &SAKI '04')
             GOTO       CMDLBL(STP1)
             ENDDO


     /*-------------------------*/
     /*  EACH RECEIVING PROGRAM */
     /*-------------------------*/
             CALL       PGM(&PROG) PARM(&LIBL &FILE)

     /*--------------------*/
     /*  SET COMPLETE DATE */
     /*--------------------*/
             CALL       PGM(EJKR08) PARM(&JYKB &LIBL &FILE &DKBN)

 @END:
             ENDPGM
