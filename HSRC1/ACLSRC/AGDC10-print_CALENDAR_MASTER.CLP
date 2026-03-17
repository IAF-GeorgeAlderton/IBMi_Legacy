             PGM
             /** AGDC10 *******************************/
             /*  PRINT CALENDAR MASTER                */
             /*  J.WATANABE  2018.09.05               */
             /*****************************************/
             DCLF       FILE(AGDPW10)

             CHGVAR     VAR(&XFROM) VALUE('201801')
             CHGVAR     VAR(&XTO )  VALUE('999999')
 STRT:
             SNDRCVF    RCDFMT(DSP01)
             CHGVAR     VAR(&IN41) VALUE('0')
             CHGVAR     VAR(&IN42) VALUE('0')
             CHGVAR     VAR(&IN85) VALUE('0')

             IF         COND(&IN01 *EQ '1') THEN(DO)
             GOTO       CMDLBL(ENDP)
             ENDDO

             IF         COND(&XFROM *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN41) VALUE('1')
             CHGVAR     VAR(&IN85) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('Enter DATE FROM !')
             GOTO       CMDLBL(STRT)
             ENDDO

             IF         COND(&XTO *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN42) VALUE('1')
             CHGVAR     VAR(&IN85) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('Enter DATE TO !')
             GOTO       CMDLBL(STRT)
             ENDDO

             OVRPRTF    FILE(QPRINT) PAGESIZE(66 198)

             OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/AGDPL12)
             CALL       AGDR11 PARM(&XFROM &XTO)

             OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A#DPL12)
             CALL       AGDR11 PARM(&XFROM &XTO)

             OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)
             CALL       AGDR11 PARM(&XFROM &XTO)

             OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A$DPL12)
             CALL       AGDR11 PARM(&XFROM &XTO)

ENDP:        ENDPGM
