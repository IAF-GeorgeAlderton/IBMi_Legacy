             PGM
             /**** GDKC09 ****************************************************/
             /*      CHANGING PAYMENT TERMS                                  */
             /*       GBC                               97/07/30             */
             /****************************************************************/
             DCLF       FILE(GDKPW09)

 ##1:        RTVDTAARA  DTAARA(GDKD01)  RTNVAR(&D1MM)
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&D#MSG) VALUE(' ')

 ##2:        SNDRCVF    RCDFMT(DSP01)

             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&IN11) VALUE('0')
             IF         COND(&IN01 = '1') THEN(GOTO CMDLBL(END))
             IF         COND(&D1MM = 0) THEN(DO)
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&D#MSG) VALUE('INPUT THE MONTHS.')
             GOTO       CMDLBL(##2)
             ENDDO
             IF         COND(&D1MM *GT 12) THEN(DO)
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&D#MSG) VALUE('INCORRECT MONTHS.')
             GOTO       CMDLBL(##2)
             ENDDO
             IF         COND(&IN05 = '0') THEN(GOTO CMDLBL(##2))

             CHGDTAARA  DTAARA(GDKD01) VALUE(&D1MM)

 END:        ENDPGM
