             PGM
/** AB#CS0 ************************************************/
/*  SERVICE PARTS MENU                                    */
/*    TCH                            01.10.16             */
/* TCHK1 06/02/09 CHG SERVICE PARTS INQUIRY               */
/* TCHK2 06/12/09 ADD TEMPORARY CHANGE CALENDAR M/F       */
/* JW1   06/22/16 ADD OPT FOR COC MAINTENANCE             */
/**********************************************************/
             DCLF       FILE(AB#PWS0)

/* TCHK4 */  OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
/* TCHK4 */  OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
/* TCHK4 */  OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             CALL       PGM(FCER63)
 @STRT:
             CHGVAR     VAR(&D@OPT) VALUE(' ')

             SNDRCVF    RCDFMT(DSP01)
             CHGVAR     VAR(&IN61) VALUE('0')

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@END))

      /*     IF         COND(&D@OPT *LT '1' *OR &D@OPT *GT '9') +
                          THEN(CHGVAR VAR(&IN61) VALUE('1')) */

  /* ORDER ENTRY        */
             IF         COND(&D@OPT *EQ '1') THEN(CALL PGM(AB#C4S))

  /* PICKUP LIST, ETC   */
             IF         COND(&D@OPT *EQ '2') THEN(CALL PGM(AB#CSI))

  /* CREATE LABE DATA   */
             IF         COND(&D@OPT *EQ '3') THEN(CALL PGM(AB#CSN))

  /* CREATE KANBAN DATA */
             IF         COND(&D@OPT *EQ '4') THEN(CALL PGM(AB#CSO))

  /* MASTER MAINTENANCE */
             IF         COND(&D@OPT *EQ '5') THEN(CALL PGM(FCER60))

  /* MASTER FILE INQUIRY */
/* TCHK1     IF         COND(&D@OPT *EQ '6') THEN(CALL PGM(FCER62)) */
/* TCHK1 */  IF         COND(&D@OPT *EQ '6') THEN(CALL PGM(FCEC62))

  /* MASTER FILE LIST   */
             IF         COND(&D@OPT *EQ '7') THEN(CALL PGM(FCEC61))

  /* DOWNLOAD FILE      */
             IF         COND(&D@OPT *EQ '8') THEN(CALL PGM(FCEC63))

             IF         COND(&D@OPT *EQ '9') THEN(CALL PGM(AB#CS1))
/*JW1*/
             IF         COND(&D@OPT *EQ 'A') THEN(CALL PGM(AB#C1G))

             IF         COND(&D@OPT *EQ 'B') THEN(CALL PGM(ALDC28))

             IF         COND(&D@OPT *EQ 'T') THEN(CALL PGM(AB#CBE))

             GOTO       CMDLBL(@STRT)

 @END:        ENDPGM
