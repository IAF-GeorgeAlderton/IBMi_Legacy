             PGM

             DCLF       FILE(SPLPW01)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&XSPL ) VALUE('QPRINT ')
             CHGVAR     VAR(&XSF# ) VALUE('1      ')
             CHGVAR     VAR(&XOUT) VALUE('1')
             CHGVAR     VAR(&XEDT) VALUE('Y')
             CHGVAR     VAR(&XBCH) VALUE('Y')

 STP1:       CHGVAR     VAR(&IN01) VALUE('0')
             SNDRCVF    RCDFMT(DSP01)
             CHGVAR     VAR(&XMSG) VALUE(' ')
             CHGVAR     VAR(&IN41) VALUE('0')
             CHGVAR     VAR(&IN42) VALUE('0')
             CHGVAR     VAR(&IN43) VALUE('0')
             CHGVAR     VAR(&IN44) VALUE('0')
             CHGVAR     VAR(&IN45) VALUE('0')
             CHGVAR     VAR(&IN46) VALUE('0')
             CHGVAR     VAR(&IN47) VALUE('0')
/* END */
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(END))

             IF         COND(&XSPL *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN41) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER SPOOL FILE NAME !')
             GOTO       STP1
             ENDDO

             IF         COND(&XJOB *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN42) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER JOB NAME !')
             GOTO       STP1
             ENDDO

             IF         COND(&XUSR *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN43) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER USER NAME !')
             GOTO       STP1
             ENDDO

             IF         COND(&XNBR *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN44) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER JOB NUMBER !')
             GOTO       STP1
             ENDDO

             IF         COND((&XOUT *NE '1') *AND (&XOUT *NE '2')) +
                          THEN(DO)
             CHGVAR     VAR(&IN46) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('OUTPUT SHOULD BE 1 OR 2 !')
             GOTO       STP1
             ENDDO

             IF         COND((&XEDT *NE 'Y') *AND (&XEDT *NE 'N')) +
                          THEN(DO)
             CHGVAR     VAR(&IN47) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER Y OR N FOR HEADER !')
             GOTO       STP1
             ENDDO

             IF         COND((&XBCH *NE 'Y') *AND (&XBCH *NE 'N')) +
                          THEN(DO)
             CHGVAR     VAR(&IN47) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER Y OR N FOR BATCH# !')
             GOTO       STP1
             ENDDO

             IF         COND(&XSF#  *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN45) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ENTER SPOOL FILE NUMBER !')
             GOTO       STP1
             ENDDO

/* CHECK SPOOL FILE */
             HLDSPLF    FILE(&XSPL) JOB(&XNBR/&XUSR/&XJOB) +
                          SPLNBR(&XSF#)

             MONMSG     MSGID(CPF3337)

             MONMSG     MSGID(CPF0001) EXEC(DO)
             CHGVAR     VAR(&IN41) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('SPOOL FILE NOT FOUND!')
             GOTO       STP1
             ENDDO

             MONMSG     MSGID(CPA0701 CPF3340) EXEC(DO)
             CHGVAR     VAR(&IN45) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('NEED SPOOL FILE NO. !')
             GOTO       STP1
             ENDDO

             IF         COND((&XEDT *EQ 'N') *AND (&XBCH *EQ 'N')) +
                          THEN(DO)
             DSPSPLF    FILE(&XSPL) JOB(&XNBR/&XUSR/&XJOB) +
                          SPLNBR(&XSF#)
             ENDDO

    /* IF NO ERROR......... */

             CALL       PGM(SPLC02) PARM(&XJOB &XUSR &XNBR &XSPL +
                          &XSF# &XOUT &XEDT &XBCH 'Y')

END:         ENDPGM
