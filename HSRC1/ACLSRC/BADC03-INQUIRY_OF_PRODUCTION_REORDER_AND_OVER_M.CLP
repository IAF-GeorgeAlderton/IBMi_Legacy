             PGM
             /** BADC03 **********************************/
             /* INQUIRY OF PRODUCTION REORDER AND OVER MADE DATA */
             /*        E.KAWASHIMA 90.03.08              */
             /********************************** BADC03 **/
             DCLF       FILE(BADPW03)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&XXX) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WS) USER(&US)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

 STP1:       SNDRCVF    DEV(&WS) RCDFMT(BADPW031)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         COND(&KBN *NE '1' *AND &KBN *NE '2') THEN(DO)
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&ERR) VALUE('NO. IS 1 2')
             GOTO       CMDLBL(STP1)
             ENDDO

             IF         (&KBN *EQ '1') THEN(DO)
             CALL       PGM(BADR04) PARM(&XXX)
             IF         (&XXX *EQ '1') THEN(DO)
             GOTO END
             ENDDO
             IF         (&XXX *EQ '3') THEN(DO)
             CHGVAR     VAR(&KBN) VALUE(' ')
             GOTO STP1
             ENDDO
             ENDDO

             IF         (&KBN *EQ '2') THEN(DO)
             CALL       PGM(BADR05) PARM(&XXX)
             IF         (&XXX *EQ '1') THEN(DO)
             GOTO END
             ENDDO
             IF         (&XXX *EQ '3') THEN(DO)
             CHGVAR     VAR(&KBN) VALUE(' ')
             GOTO STP1
             ENDDO
             ENDDO

 END:        ENDPGM
