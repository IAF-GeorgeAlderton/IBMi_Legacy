             PGM
             /** AFDC14 *******************************/
             /*  PRINT NOT RETURNED BOX REPORT        */
             /*  J.WATANABE  2018.09.18               */
             /*****************************************/
             DCLF       FILE(AFDPW14)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30)
             DCL        VAR(&TRUE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&FNAM) VALUE('OUTSRC NOT RETURNED BOX +
                          REPORT')

             CHGVAR     VAR(&XFROM) VALUE('20180101')
             CHGVAR     VAR(&XTO )  VALUE('99999999')
 STRT:
             SNDRCVF    RCDFMT(DSP01)
             CHGVAR     VAR(&XMSG) VALUE(' ')
             CHGVAR     VAR(&IN41) VALUE('0')
             CHGVAR     VAR(&IN42) VALUE('0')
 /* F1 EXIT */
             IF         COND(&IN01 *EQ '1') THEN(DO)
             GOTO       CMDLBL(ENDP)
             ENDDO

             IF         COND(&XFROM *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN41) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('Enter ORDER DATE FROM !')
             GOTO       CMDLBL(STRT)
             ENDDO

             CALL       UTLR01 (&XFROM &TRUE &RTN)
             IF         COND(&RTN *NE ' ') THEN(DO)
             CHGVAR     VAR(&IN41) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ORDER DATE FROM IS INCORRECT!')
             GOTO       CMDLBL(STRT)
             ENDDO

             IF         COND(&XTO *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN42) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('Enter ORDER DATE TO!')
             GOTO       CMDLBL(STRT)
             ENDDO

             IF         COND(&XTO *NE '99999999') THEN(DO)
             CALL       UTLR01 (&XTO &TRUE &RTN)
             IF         COND(&RTN *NE ' ') THEN(DO)
             CHGVAR     VAR(&IN42) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ORDER DATE TO IS INCORRECT!')
             GOTO       CMDLBL(STRT)
             ENDDO
             ENDDO

             IF         COND(&XFROM *GT &XTO) THEN(DO)
             CHGVAR     VAR(&IN42) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ERROR DATE! (FROM > TO)')
             GOTO       CMDLBL(STRT)
             ENDDO

 /* F5 RUN */
             IF         COND(&IN05 *NE '1') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('Press F5 to create csv +
                          report...')
             GOTO       CMDLBL(STRT)
             ENDDO


             CLRPFM     FILE(AFDWP14)
             CLRPFM     FILE(AFDWP14B)

             CALL       AFDR14  PARM(&XFROM &XTO)
             CALL       AFDR14B PARM(&XFROM &XTO)

             CALL   APLC94 PARM('2' 'AFDWP14B' 'HWFILE1' &FNAM 'Y' '' 'Y')

ENDP:        ENDPGM
