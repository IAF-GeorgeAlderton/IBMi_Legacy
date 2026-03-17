             PGM
             /*** AL#CTB ***********************************/
             /*   CHECK TOYOTA WEB DATA                    */
             /*   JW    2018.08.17                         */
             /**********************************************/
             DCLF       FILE(AL#PWTB)

             DCL        VAR(&TRUE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN )  TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&XFROM) VALUE('20190101')
             CHGVAR     VAR(&XSLCT ) VALUE('1')
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
             CHGVAR     VAR(&XMSG) VALUE('Enter DATE FROM !')
             GOTO       CMDLBL(STRT)
             ENDDO

             CALL       UTLR01 (&XFROM &TRUE &RTN)
             IF         COND(&RTN *NE ' ') THEN(DO)
             CHGVAR     VAR(&IN41) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('DATE FROM IS INCORRECT!')
             GOTO       CMDLBL(STRT)
             ENDDO

             CHGVAR     VAR(&XFROM) VALUE(&TRUE)

             IF         COND(&XSLCT *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN42) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('Enter PRINTER SELECTION !')
             GOTO       CMDLBL(STRT)
             ENDDO

             IF         COND((&XSLCT *NE '1') *AND (&XSLCT *NE '9')) +
                          THEN(DO)
             CHGVAR     VAR(&IN42) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('PRINTER SELECTION SHOULD BE 1..')
             GOTO       CMDLBL(STRT)
             ENDDO

 /* F5 RUN */
             IF         COND(&IN05 *NE '1') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('Press F5 to print report...')
             GOTO       CMDLBL(STRT)
             ENDDO

 /* SET PRINTER   */
             IF         COND(&XSLCT *EQ '1') THEN(DO)
             OVRPRTF    FILE(QPRINT) PAGESIZE(66 132) LPI(6) +
                          OVRFLW(60) OUTQ(LANPRT03) FORMTYPE(K6H1)
             ENDDO
             IF         COND(&XSLCT *EQ '9') THEN(DO)
             OVRPRTF    FILE(QPRINT) PAGESIZE(66 132) LPI(6) +
                          OVRFLW(60) OUTQ(EPRINT1 ) FORMTYPE(K6H1)
             ENDDO

 /* PRINT PROCESS */
             DLTF       FILE(QTEMP/AL#WP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTDUPOBJ  OBJ(AL#WP01) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)

             OVRDBF     FILE(AL#WP01) TOFILE(QTEMP/AL#WP01)

             CALL       PGM(AL#RTB) PARM(&XFROM)
             CALL       PGM(AL#RTC) PARM(&XFROM)

             DLTOVR     FILE(*ALL)
ENDP:
             ENDPGM
