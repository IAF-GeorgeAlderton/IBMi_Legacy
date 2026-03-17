             PGM
             /** UTLC74 *********************************************/
             /*  REMOVE SPOOL FILE AND SAVE TO OUTQ                 */
             /*  JW :  2019.10.21                                   */
             /*******************************************************/
             DCLF       FILE(UTLPW74)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)

 STP0:   /*  CHGVAR     VAR(&NO1) VALUE(' ')  */
 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(DSP01)

             CHGVAR     VAR(&IN41) VALUE('0')
             CHGVAR     VAR(&IN42) VALUE('0')
             CHGVAR     VAR(&IN43) VALUE('0')
             CHGVAR     VAR(&IN44) VALUE('0')
             CHGVAR     VAR(&IN45) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO ENDP

             IF         COND((&XOUT1 *EQ ' ')) THEN(DO)
             CHGVAR     VAR(&IN41) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER OUTQ FROM !')
             GOTO       STP1
             ENDDO

             IF         COND((&XLIB1 *EQ ' ')) THEN(DO)
             CHGVAR     VAR(&IN42) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER LIBRARY FROM !')
             GOTO       STP1
             ENDDO

             IF         COND((&XDATE *EQ ' ')) THEN(DO)
             CHGVAR     VAR(&IN43) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER DATE !')
             GOTO       STP1
             ENDDO

             IF         COND((&XOUT2 *EQ ' ')) THEN(DO)
             CHGVAR     VAR(&IN44) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER OUTQ TO !')
             GOTO       STP1
             ENDDO

             IF         COND((&XLIB2 *EQ ' ')) THEN(DO)
             CHGVAR     VAR(&IN45) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER LIBRARY TO !')
             GOTO       STP1
             ENDDO

             CHGVAR     VAR(&XMSG) VALUE('GO TO NEXT !')
             GOTO       STP1

             CALL       PGM(UTLC71)

ENDP:
             ENDPGM
