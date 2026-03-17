             PGM
             /** GBFC46 ************************************/
             /*  CORRECTION OF SALES UNIT PRICE  QUOTATION DATA */
             /*       S.YAMAGAMI            91.10.23       */
             /*       GBC                 2000.07.20       */
             /************************************ GBFC46 **/
             DCLF       FILE(GBFPW46)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL1) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WKOJO) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WS)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

 @001:       SNDRCVF    DEV(&WS) RCDFMT(GBFPW461)
             IF         COND(&IN15 *EQ '1') THEN(GOTO CMDLBL(END))
             CHGVAR     VAR(&IN01) VALUE('0')
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

          /*  nhbﾅg ﾎﾞ[]h  */
             IF         COND(&@TOKU *EQ '    ') THEN(DO)
             CHGVAR     VAR(&IN01) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) +
                          VALUE(' INPUT USER                 ')
             GOTO       CMDLBL(@001)
             ENDDO

          /*  ﾃcﾆﾞｭc ﾎﾞ[]h  */
             IF         COND(&@KOJO *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) VALUE(' INPUT PLANT            ')
             GOTO       CMDLBL(@001)
             ENDDO

             IF         COND(&@KOJO *EQ '*') THEN(DO)
             CHGVAR     VAR(&WKOJO) VALUE('@')
             ENDDO

             IF         COND(&@KOJO *NE '*') THEN(DO)
             CHGVAR     VAR(&WKOJO) VALUE(&@KOJO)
             ENDDO

             CHGVAR     VAR(&FIL1) VALUE('GBF' *CAT &@TOKU *CAT &WKOJO)

             CHKOBJ     OBJ(&FIL1) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CHGVAR     VAR(&IN01) VALUE('1')
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) +
                          VALUE(' CONFIRM USER & PLANT         ')
             GOTO       CMDLBL(@001)
             ENDDO

             OVRDBF     FILE(GBFNP44) TOFILE(&FIL1)
             CALL       PGM(GBFR46) PARM(&@TOKU &@KOJO)
             DLTOVR     FILE(*ALL)

END:         ENDPGM
