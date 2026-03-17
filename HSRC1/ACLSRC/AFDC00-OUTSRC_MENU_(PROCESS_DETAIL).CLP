             PGM
             /** AFDC00 **************************************/
             /*  OUTGOING DETAIL                             */
             /*      TO CURTIS (SUPPLYER CODE = 2222)        */
             /* TCH 2001.12.12                               */
             /* TCH 2002.07.26 APPLY OTHER SUPPLIERS         */
             /*                                              */
             /* TCHK1 11/02/07 ADD NEW OPTION '9'            */
             /* TCHK2 12/03/08 ADD PTC(2424)                 */
             /* TCHK3 02/26/09 ADD DEPOR(2929)               */
             /* TCHK4 03/14/10 ADD SWD(2828),TALMA(3333)     */
             /* TCHK5 05/13/10 ADD SEKIDO(3111),SRA(3222),VICO(3444)*/
             /* TCHK6 03/07/11 ADD FCO(Forest City Ohio(2112)       */
             /* TCHK7 01/27/12 ADD ROCKFORD SECONDARIES(4444)       */
             /* TCHK8 09/20/12 ADD FAS(5555)                        */
             /* JW1   2023.010.11 ADD ERROR MSG                     */
             /*******************************************************/
             DCLF       FILE(AFDPW00)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKCD)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&EID)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&SUPP)    TYPE(*CHAR) LEN(4)

        /*   CHGVAR     VAR(&SUPP) VALUE('2222')   */
             RTVJOBA      USER(&USER)

   STRT:
             SNDRCVF    RCDFMT(DSP01)
             CHGVAR     VAR(&IN61) VALUE('0')
             CHGVAR     VAR(&IN62) VALUE('0')
             CHGVAR     VAR(&IN63) VALUE('0')
             CHGVAR     VAR(&XMSG) VALUE(' ')

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(END))
             IF         COND(&IN03 *EQ '1') THEN(GOTO CMDLBL(END))

             IF         COND(&OPTN *EQ ' ') +
                          THEN(DO)
             CHGVAR     VAR(&IN61) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER OPTION!  ')
             GOTO       CMDLBL(STRT)
             ENDDO

             IF         COND((&OPTN *LT '1') *OR (&OPTN *GT '9')) +
                          THEN(DO)
             CHGVAR     VAR(&IN61) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('OPTION SHOULD BE 1 TO 8!')
             GOTO       CMDLBL(STRT)
             ENDDO

             IF         COND(&SUPP *EQ '    ' *AND &OPTN *NE '8') +
                          THEN(DO)
             CHGVAR     VAR(&IN62) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER SUPPLIER CODE!  ')
             GOTO       CMDLBL(STRT)
             ENDDO

             IF         COND(&SUPP *EQ '2888' *AND &SUPX *NE '1' +
                          *AND &SUPX *NE '2') THEN(DO)
             CHGVAR     VAR(&IN63) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER SUB CODE!  ')
             GOTO       CMDLBL(STRT)
             ENDDO

             IF         COND(&SUPP *NE '2888' *AND &SUPX *NE ' ') +
                          THEN(DO)
             CHGVAR     VAR(&IN63) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('DO NOT ENTER SUB CODE!  ')
             GOTO       CMDLBL(STRT)
             ENDDO

             IF         COND(&SUPP *NE '2222' *AND  +
                             &SUPP *NE '2111' *AND +
                             &SUPP *NE '2112' *AND +
                             &SUPP *NE '2333' *AND +
                             &SUPP *NE '2444' *AND +
                             &SUPP *NE '2666' *AND +
                             &SUPP *NE '2424' *AND +
                             &SUPP *NE '2555' *AND +
                             &SUPP *NE '2777' *AND +
                             &SUPP *NE '2888' *AND +
                             &SUPP *NE '2999' *AND +
                             &SUPP *NE '2929' *AND +
                             &SUPP *NE '2828' *AND +
                             &SUPP *NE '3333' *AND +
                             &SUPP *NE '3111' *AND +
                             &SUPP *NE '4456' *AND +
                             &SUPP *NE '3222' *AND +
                             &SUPP *NE '3444' *AND +
                             &SUPP *NE '4444' *AND +
                             &SUPP *NE '5555' *AND +
                             &OPTN *NE '8') THEN(DO)
             CHGVAR     VAR(&IN61) VALUE('1')
             CHGVAR     VAR(&IN62) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('INCORRECT SUPPLIER CODE!  ')
             GOTO       CMDLBL(STRT)
             ENDDO

   /* CREATE ORDER */
             IF         COND(&OPTN *EQ '1') THEN(CALL PGM(AFDC03) +
                          PARM(&SUPP &SUPX))

   /* SHIPPING DOCUMENTS */
             IF         COND(&OPTN *EQ '2') THEN(CALL PGM(AFDC04) +
                          PARM(&SUPP &SUPX))

   /* ORDER INQUIRY      */
             IF         COND(&OPTN *EQ '3') THEN(CALL PGM(AFDC05) +
                          PARM(&SUPP &SUPX))

   /* ORDER INQUIRY      */
             IF         COND(&OPTN *EQ '4') THEN(CALL PGM(AFDC06) +
                          PARM(&SUPP &SUPX))

   /* CANCEL             */
             IF         COND(&OPTN *EQ '5') THEN(DO)
             CALL       PGM(AFBR8W) PARM(&WKCD &EID)
             IF         COND(&EID *EQ ' ') THEN(CALL PGM(AFDC02) +
                          PARM(&USER &WKCD &SUPP &SUPX))
             ENDDO

   /* CANCEL RECEIVING   */
             IF         COND(&OPTN *EQ '6') THEN(CALL PGM(AFDC08) +
                          PARM(&SUPP &SUPX))

   /* CHANGE BIN         */
             IF         COND(&OPTN *EQ '7') THEN(CALL PGM(AFDC09) +
                          PARM(&SUPP &SUPX))

   /* CREATE DATA        */
       /**JW IF         COND(&OPTN *EQ '8') THEN(CALL PGM(AFDC10))  **/
             IF         COND(&OPTN *EQ '8') THEN(CALL PGM(AFDC10A) +
                          PARM((&SUPP)))

   /* PRINT SCANNED DATA */ /* TCHK1 */
             IF         COND(&OPTN *EQ '9') THEN(CALL PGM(AFDC30) +
                          PARM(&SUPP &SUPX))

             CHGVAR     VAR(&OPTN) VALUE(' ')
             GOTO       CMDLBL(STRT)
 END:
             ENDPGM
