             PGM
/** AB#CF1A **********************************************************/
/*  FORD INQUIRY MENU                                                */
/*  JW   2022.01.31                                                  */
/*-------------------------------------                              */
/*  JW1  2023.07.24 ADD OPT5 AB#CAQI                                 */
/*********************************************************************/
             DCLF       FILE(AB#PWF1A)
             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
 STP1:
             SNDRCVF    DEV(&WSID) RCDFMT(DSP01)

             CHGVAR     VAR(&IN41) VALUE('0')
             CHGVAR     VAR(&XMSG) VALUE(' ')

             IF         (&IN01 *EQ '1') GOTO ENDP
             IF         (&IN12 *EQ '1') GOTO ENDP

             IF         (&XSEL *EQ 0) THEN(DO)
             CHGVAR     VAR(&IN41) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER OPTION !')
             GOTO       STP1
             ENDDO

             IF         COND((&XSEL *LT 1) *OR (&XSEL *GT 9)) THEN(DO)
             CHGVAR     VAR(&IN41) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('OPTION SHOULD BE 1 TO 9 !')
             GOTO       STP1
             ENDDO

 /***************/
 /*** PROCESS ***/
 /***************/

 /* SHIPPING STATUS */
     /**     IF         COND(&XSEL *EQ 1) THEN(DO)    **/
     /**     CALL       PGM(AB#C9M4)                  **/
     /**     GOTO       STP9                          **/
     /**     ENDDO                                    **/

 /* NOTE */
             IF         COND(&XSEL *EQ 1) THEN(DO)
             CALL       PGM(AB#RFR)
             GOTO       STP9
             ENDDO

 /* ASN  */
             IF         COND(&XSEL *EQ 2) THEN(DO)
             CALL       PGM(JCMR20B)
             GOTO       STP9
             ENDDO

 /* ASN RECEIVED FROM FORD */
             IF         COND(&XSEL *EQ 3) THEN(DO)
             CALL       PGM(ABFR42)
             GOTO       STP9
             ENDDO

 /* LABLE INQ */
             IF         COND(&XSEL *EQ 4) THEN(DO)
             CALL       PGM(ABFR44)
             GOTO       STP9
             ENDDO

 /* LABLE STATUS INQ */
             IF         COND(&XSEL *EQ 5) THEN(DO)
             CALL       PGM(AB#CAQI)
             GOTO       STP9
             ENDDO

 /* EDI 862 INQ */
             IF         COND(&XSEL *EQ 6) THEN(DO)
             CALL       PGM(ABFR20 )
             GOTO       STP9
             ENDDO

 /* PLANT & CONTAINER INQ */
             IF         COND(&XSEL *EQ 7) THEN(DO)
             CALL       PGM(FBCR48 )
             GOTO       STP9
             ENDDO

 /* PLANT & DELIVERY# INQ BY PLANT */
             IF         COND(&XSEL *EQ 8) THEN(DO)
/*JW ******* CALL       PGM(ABFR07 ) PARM('')   ********/
             CALL       PGM(ABFR07A) PARM('')
             GOTO       STP9
             ENDDO

 /* PLANT & DELIVERY# INQ BY DELIVE# */
             IF         COND(&XSEL *EQ 9) THEN(DO)
             CALL       PGM(ABFR08 ) PARM('')
             GOTO       STP9
             ENDDO

 STP9:
             CHGVAR     VAR(&XSEL) VALUE(0)
             GOTO       STP1
 ENDP:
             ENDPGM
