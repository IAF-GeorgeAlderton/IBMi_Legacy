             PGM
             /** GBFC45 ************************************/
             /*  UPDATE LIST OF SALES UNIT PRICE QUOTATION DATA */
             /*       S.YAMAGAMI            91.10.22       */
             /*       GBC                 2000.07.20       */
             /************************************ GBFC45 **/
             DCLF       FILE(GBFPW45)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL1) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WKOJO) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WS)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

 @001:       SNDRCVF    DEV(&WS) RCDFMT(GBFPW451)
             IF         COND(&IN10 *EQ '1') THEN(GOTO CMDLBL(END))
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

             IF         COND(&IN11 *EQ '0') THEN(GOTO CMDLBL(@001))

             CHGVAR     VAR(&FIL1) VALUE('GBF' *CAT &@TOKU *CAT &WKOJO)

             OVRPRTF    FILE(QPRINT) PAGESIZE(66 132) LPI(6) +
                          OVRFLW(60) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1)

             CHGVAR     VAR(&FIL1) VALUE('GBF' *CAT &@TOKU *CAT &WKOJO)

             OVRDBF     FILE(GBFNP44) TOFILE(&FIL1)

             DLTF       FILE(GBFWP45)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/GBFWP45) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(GBFR45)

             DLTF       FILE(GBFWP45)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTOVR     FILE(*ALL)

END:         ENDPGM
