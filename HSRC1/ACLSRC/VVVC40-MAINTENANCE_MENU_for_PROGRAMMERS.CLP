             PGM
             /** VVVC40 ************************************************/
             /*  MAINTENANCE MENU FOR PROGRAMMERS                      */
             /*  JW   2025.05.21                                       */
             /**********************************************************/

             DCLF       FILE(VVVPW40 )

  STP1:      SNDRCVF    RCDFMT(DSP01)

/* END */
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(ENDP))
             IF         COND(&IN03 *EQ '1') THEN(GOTO CMDLBL(ENDP))
             IF         COND(&IN12 *EQ '1') THEN(GOTO CMDLBL(ENDP))

/* 1. EDIR74 -------------------------------------*/
             IF         COND(&XOPT *EQ 1) THEN(DO)
             CALL       PGM(EDIR74  )
             CHGVAR     VAR(&XOPT) VALUE(0)
             GOTO CMDLBL(STP1)
             ENDDO

/* 2. XXXXXX -------------------------------------*/
             IF         COND(&XOPT *EQ 2) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('THIS OPTION IS NOT AVAILABLE !')
             GOTO CMDLBL(STP1)
             ENDDO

/* 3. XXXXXX -------------------------------------*/
             IF         COND(&XOPT *EQ 3) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('THIS OPTION IS NOT AVAILABLE !')
             GOTO CMDLBL(STP1)
             ENDDO

/* 4. XXXXXX -------------------------------------*/
             IF         COND(&XOPT *EQ 4) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('THIS OPTION IS NOT AVAILABLE !')
             GOTO CMDLBL(STP1)
             ENDDO

             CHGVAR     VAR(&MSG) VALUE('ENTER CORRECT OPTION!')
             GOTO CMDLBL(STP1)

 ENDP:       ENDPGM
