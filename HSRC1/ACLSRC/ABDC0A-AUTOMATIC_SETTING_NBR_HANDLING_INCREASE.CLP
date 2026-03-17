             PGM
             /** ABDC0A **********************************/
             /*AUTOMATIC SETTING NBR HANDLING INCREASE & DECREASE MEASURE MENU*/
             /* A-PICS1                                */
             /*        KOHHY.            90.11.30        */
             /********************************** ABDC0A **/
             DCLF       FILE(ABDPW0A)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&KBN) TYPE(*CHAR) LEN(1) VALUE(' ')

             RTVJOBA    JOB(&WS) USER(&US)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

 STP1:       SNDRCVF    DEV(&WS) RCDFMT(ABDPW0A1)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN11) VALUE('0')

             IF         COND(&OP *NE '1' *AND &OP *NE '2' *AND &OP +
                          *NE '3' *AND &OP *NE '4') THEN(DO)
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&ERR) VALUE('NO. ISN')
             GOTO       CMDLBL(STP1)
             ENDDO

 /* OP = '1' */
             IF         COND(&OP *EQ '1') THEN(DO)
             CALL       PGM(ABDC01)
             CHGVAR     VAR(&OP) VALUE(' ')
             GOTO       CMDLBL(STP1)
             ENDDO

 /* OP = '2' */
             IF         COND(&OP *EQ '2') THEN(DO)
             CALL       PGM(ABDC02)
             CHGVAR     VAR(&OP) VALUE(' ')
             GOTO       CMDLBL(STP1)
             ENDDO

 /* OP = '3' */
             IF         COND(&OP *EQ '3') THEN(DO)
             CALL       PGM(ABDC04)
             CHGVAR     VAR(&OP) VALUE(' ')
             GOTO       CMDLBL(STP1)
             ENDDO

 /* OP = '4' */
             IF         COND(&OP *EQ '4') THEN(DO)
             CALL       PGM(ABDC05)
             CHGVAR     VAR(&OP) VALUE(' ')
             GOTO       CMDLBL(STP1)
             ENDDO

 END:        ENDPGM
