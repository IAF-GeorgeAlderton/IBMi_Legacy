             PGM
/** AB#CBE *************************************************/
/*  TMS MENU                                               */
/*                                                         */
/* TCHK1 2012/22/09 ADD OPT.4 & 5                          */
/* JW1   2015/11/05 ADD OPT.7                              */
/* %0001 2015/12/02 ADD OPT.8    TUCKER                    */
/* LEC   2022/06/15 ADD OPT.9                              */
/***********************************************************/
             DCLF       FILE(AB#PWBE)

 @STRT:
             CHGVAR     VAR(&D@OPT) VALUE(' ')

             SNDRCVF    RCDFMT(DSP01)

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@END))

  /* CASE LABEL         */
             IF         COND(&D@OPT *EQ '1') THEN(CALL PGM(AB#CBB))

  /* INQUIRY            */
             IF         COND(&D@OPT *EQ '2') THEN(CALL PGM(AB#RBC))

  /* BILL OF LADING     */
             IF         COND(&D@OPT *EQ '3') THEN(CALL PGM(AB#CBD))

  /* OLD CASE LABEL CREATE AFTER PACKING */
  /* JW      IF         COND(&D@OPT *EQ '4') THEN(CALL PGM(AB#CBG))  */

  /* CASE LABEL RE-CREATE AFTER PACKING */
             IF         COND(&D@OPT *EQ '5') THEN(CALL PGM(AB#CBH))

  /* NEW CASE LABEL CREATE AFTER PACKING */
             IF         COND(&D@OPT *EQ '6') THEN(CALL PGM(AB#CBI))

  /* JW(SRA) CREATE CSV INTO USER DIRECTORY      */
             IF         COND(&D@OPT *EQ '7') THEN(CALL PGM(AB#C72))

  /* %0001   CREATE SHIPPING DATA  */
             IF         COND(&D@OPT *EQ '8') THEN(CALL PGM(ANPC03))

  /* TOYOTA SERVICE PARTS SHORTAGE SCAN          */
             IF         COND(&D@OPT *EQ '9') THEN(CALL PGM(ALDC27))

             GOTO       CMDLBL(@STRT)

 @END:        ENDPGM
