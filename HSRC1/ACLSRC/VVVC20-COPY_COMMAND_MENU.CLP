             PGM
             /** VVVC20 ************************************************/
             /*  COPY PROGRAM MENU                                     */
             /*  JW   2024.02.19                                       */
             /**********************************************************/

             DCLF       FILE(VVVPW20 )

  STP1:      SNDRCVF    RCDFMT(DSP01)

/* END */
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(ENDP))
             IF         COND(&IN03 *EQ '1') THEN(GOTO CMDLBL(ENDP))
             IF         COND(&IN12 *EQ '1') THEN(GOTO CMDLBL(ENDP))

             IF         COND((&XOPT *NE 1) *AND (&XOPT *NE 2) *AND +
                          (&XOPT *NE 3) *AND (&XOPT *NE 4)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('ENTER CORRECT OPTION!')
             GOTO CMDLBL(STP1)
             ENDDO

/* 1. VVVC21 -------------------------------------*/
             IF         COND(&XOPT *EQ 1) THEN(DO)
             CALL       PGM(VVVC21  )
             CHGVAR     VAR(&XOPT) VALUE(0)
             GOTO CMDLBL(STP1)
             ENDDO

/* 2. VVVC23 -------------------------------------*/
             IF         COND(&XOPT *EQ 2) THEN(DO)
             CALL       PGM(VVVC23  )
             CHGVAR     VAR(&XOPT) VALUE(0)
             GOTO CMDLBL(STP1)
             ENDDO

/* 3. VVVC22 -------------------------------------*/
             IF         COND(&XOPT *EQ 3) THEN(DO)
             CALL       PGM(VVVC22  )
             CHGVAR     VAR(&XOPT) VALUE(0)
             GOTO CMDLBL(STP1)
             ENDDO

/* 4. UAPR01 -------------------------------------*/
             IF         COND(&XOPT *EQ 4) THEN(DO)
             CALL       PGM(UAPR01  )
             CHGVAR     VAR(&XOPT) VALUE(0)
             GOTO CMDLBL(STP1)
             ENDDO


 ENDP:       ENDPGM
