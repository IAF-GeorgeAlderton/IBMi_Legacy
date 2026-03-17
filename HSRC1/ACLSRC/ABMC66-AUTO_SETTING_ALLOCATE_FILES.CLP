             PGM
             /** ABMC66 ************************************/
             /*  AUTO SETTING - ALLOCATE FILES             */
             /*  JW   2021.11.12                           */
             /**********************************************/
             DCL        VAR(&ALCFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&COUNT)  TYPE(*DEC)  LEN(2 0)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&ANS)    TYPE(*CHAR) LEN(1)

             CHGVAR   VAR(&ALCFLG) VALUE(' ')
             CHGVAR   VAR(&COUNT ) VALUE(0)
START:

/* AAMPP11 */
             ALCOBJ OBJ((AAMPP11 *FILE *EXCL)) WAIT(1)
             MONMSG   MSGID(CPF0000) EXEC(DO)
             CHGVAR   VAR(&ALCFLG) VALUE('N')
             ENDDO
/* AAFPP01 */
             ALCOBJ OBJ((AAFPP01 *FILE *EXCL)) WAIT(1)
             MONMSG   MSGID(CPF0000) EXEC(DO)
             CHGVAR   VAR(&ALCFLG) VALUE('N')
             ENDDO
/* AAHPP01 */
             ALCOBJ OBJ((AAHPP01 *FILE *EXCL)) WAIT(1)
             MONMSG   MSGID(CPF0000) EXEC(DO)
             CHGVAR   VAR(&ALCFLG) VALUE('N')
             ENDDO

             IF      COND(&ALCFLG *EQ 'N') THEN(DO)
             DLCOBJ  OBJ((AAMPP11 *FILE *EXCL))
             DLCOBJ  OBJ((AAFPP01 *FILE *EXCL))
             DLCOBJ  OBJ((ABHPP01 *FILE *EXCL))

             DLYJOB  DLY(60)
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
             IF         COND(&COUNT *LE 5) THEN(GOTO CMDLBL(START))
 @MSG:
             CHGVAR     VAR(&COUNT) VALUE(0)

  /********************************************************************/
  /* CHECK OBJECT LOCK                                                */
  /*         CALL       PGM(AB#C1J)                                   */
  /*                                                                  */
  /* FOR ERROR TIME HANDLING                                          */
  /*         RTVMBRD    FILE(HWFILE1/AB#WP1J1) NBRCURRCD(&RECW1J)     */
  /*         IF         COND(&RECW1J *GT 0) THEN(DO)                  */
  /*         CHGVAR     VAR(&MSG1) VALUE('GENTRAN IS NOT WORKING ')   */
  /*         CHGVAR     VAR(&MSG2) VALUE(&MSG1 *BCAT &EDATE *TCAT +   */
  /*                      '-' *TCAT &ETIME)                           */
  /*         SNDDST     TYPE(*FILE) +                                 */
  /*                      TOINTNET(('AS400-SYSTEM@IAFI.COM')) +       */
  /*                      DSTD(&MSG2) MSG('GENTRAN HAS NOT BEEN +     */
  /*                      WORKING. PLEASE SEE ATTACHED FILE TO +      */
  /*                      CHECK WHO IS USING AND REPLY QSYOPR +       */
  /*                      MESSAGE.') DOCFILE(HWFILE1/AB#WP1J1) +      */
  /*                      DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD(&MSG2)     */
  /*         ENDDO                                                    */
  /********************************************************************/

             SNDPGMMSG  MSG('AUTO SETTING HAD AN ERROR DURING +
                          ALLOCATING FILES. PLEASE CONTACT IT +
                          MEMBER. ENTER "R" TO RETRY PROCESS') +
                          TOMSGQ(QSYSOPR) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&ANS)

             IF         COND(&ANS *EQ 'R' *OR &ANS *EQ 'r') +
                          THEN(GOTO CMDLBL(START))
             GOTO       CMDLBL(@MSG)
             ENDDO

 ENDP:       ENDPGM
