             PGM
             /*= AAFCS0 ===============================================*/
             /*  PROGRAM    : CREATE CAPACITY CHECK DATA               */
             /*  WRITTEN    : 2014/08/05                               */
             /*                                                        */
             /*  JW1     2017.09.13 DELETE OPTION 2/3/4/5              */
             /*  JW2     2018.09.14 ADD F10 FUNCTION                   */
             /*========================================================*/

             DCLF       FILE(AAFPWS0)

 STEP1:      SNDRCVF    RCDFMT(DSP01)
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&IN11) VALUE('0')

 /* F01 EXIT */
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(#END))

 /* F10 GRP CODE MAINT. */
             IF         COND(&IN10 *EQ '1') THEN(DO)
             CALL       PGM(EDIC54)
             GOTO       CMDLBL(STEP1)
             ENDDO

             IF         COND(&D1NO *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&D1ERR) VALUE('ENTER OPTION!')
             GOTO       CMDLBL(STEP1)
             ENDDO

             IF         COND((&D1NO *NE '1') *AND (&D1NO *NE '9') +
                          *AND (&D1NO *NE 'A') *AND (&D1NO *NE 'B')  +
                          *AND (&D1NO *NE 'C') *AND (&D1NO *NE 'D')) +
                          THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&D1ERR) VALUE('OPTION SHOULD BE 1, 9, A, +
                          B, C OR D..')
             GOTO       CMDLBL(STEP1)
             ENDDO

             IF         COND(&D1NO *EQ '1') THEN(DO)
             CALL       PGM(ABHCS1)
             ENDDO

         /*  DELETED  BY JW                               */
         /*  IF         COND(&D1NO *EQ '2') THEN(DO)      */
         /*  CALL       PGM(ADHCS1)                       */
         /*  ENDDO                                        */
         /*  IF         COND(&D1NO *EQ '3') THEN(DO)      */
         /*  CALL       PGM(AAFCS1)                       */
         /*  ENDDO                                        */
         /*  IF         COND(&D1NO *EQ '4') THEN(DO)      */
         /*  CALL       PGM(AAHCS1)                       */
         /*  ENDDO                                        */
         /*  IF         COND(&D1NO *EQ '5') THEN(DO)      */
         /*  CALL       PGM(AAFCS3)                       */
         /*  ENDDO                                        */

             IF         COND(&D1NO *EQ '9') THEN(DO)
             CALL       PGM(INVC41)
             ENDDO
 /* NEW LAYOUT */
             IF         COND(&D1NO *EQ 'A') THEN(DO)
             CALL       PGM(ADHCS3)
             ENDDO
             IF         COND(&D1NO *EQ 'B') THEN(DO)
             CALL       PGM(AAFCS4)
             ENDDO
             IF         COND(&D1NO *EQ 'C') THEN(DO)
             CALL       PGM(AAHCS6)
             ENDDO
             IF         COND(&D1NO *EQ 'D') THEN(DO)
             CALL       PGM(AAFCS5)
             ENDDO
 #END:
             ENDPGM
