             PGM
             /** GBFC43 ************************************/
             /*   UPDATE TRANZACTION OF SALES UNIT PRICE QUOTATION DATA */
             /*       S.YAMAGAMI            91.10.18       */
             /*       GBC                 2000.07.19       */
             /************************************ GBFC43 **/
             DCLF       FILE(GBFPW43)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL2) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WKOJO) TYPE(*CHAR) LEN(1)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             RTVJOBA    JOB(&WS)

 @001:       SNDRCVF    DEV(&WS) RCDFMT(GBFPW431)
             IF         COND(&IN10 *EQ '1') THEN(GOTO CMDLBL(END))
             CHGVAR     VAR(&IN01) VALUE('0')
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN05) VALUE('0')
             CHGVAR     VAR(&IN06) VALUE('0')
             CHGVAR     VAR(&IN07) VALUE('0')
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

          /*  1,2,3, fﾞ ﾇsﾞmﾎﾞ[]hﾉ  */
             IF         COND(&@SYOKA *EQ ' ' *AND &@KMK1 *EQ ' ' +
                          *AND &@KMK2 *EQ ' ' *AND &@KMK3 *EQ ' ' +
                          *AND &@KMK4 *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN05) VALUE('1')
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) +
                          VALUE('INPUT 1,2 OR 3.                 ')
             GOTO       CMDLBL(@001)
             ENDDO

          /*  1 ･ ﾈ]jh  */
             IF         COND(&@SYOKA *NE ' ' *AND &@SYOKA *NE '0') +
                          THEN(DO)
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) +
                          VALUE(' REVERSED IS BLANK OR ZERO.')
             GOTO       CMDLBL(@001)
             ENDDO

             IF         COND(&@SYOKA *EQ '0') THEN(DO)
             IF         COND(&@KMK1 *NE ' ' *OR &@KMK2 *NE ' ' *OR +
                          &@KMK3 *NE ' ' *OR &@KMK4 *NE ' ') THEN(DO)
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN05) VALUE('1')
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) VALUE(' REVERSED IS BLANK.')
             GOTO       CMDLBL(@001)
             ENDDO
             ENDDO

          /*  2 ･ ﾈ]jh  */
             IF         COND(&@KMK1 *NE ' ') THEN(DO)

             IF         COND(&@KMK1 *NE '1' *AND &@KMK1 *NE '2' *AND +
                          &@KMK1 *NE '3') THEN(DO)
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) +
                          VALUE(' REVERSED IS 1,2 OR 3.')
             GOTO       CMDLBL(@001)
             ENDDO

             IF         COND(&@SYOKA *NE ' ' *OR &@KMK2 *NE ' ' *OR +
                          &@KMK3 *NE ' ' *OR &@KMK4 *NE ' ') THEN(DO)
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN05) VALUE('1')
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) VALUE(' REVERSED IS BLANK.')
             GOTO       CMDLBL(@001)
             ENDDO

             ENDDO

          /*  3 ･ ﾈ]jh  */

             IF         COND(&@SYOKA *EQ ' ' *AND &@KMK1 *EQ ' ') +
                          THEN(DO)
             IF         COND(&@KMK3 *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) +
                          VALUE(' INPUT REVERSED.')
             GOTO       CMDLBL(@001)
             ENDDO

             IF         COND(&@KMK4 *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) +
                          VALUE(' INPUT REVERSED.')
             GOTO       CMDLBL(@001)
             ENDDO
             ENDDO

             IF         COND(&@KMK3 *NE ' ' *AND &@KMK4 *EQ ' ') +
                          THEN(DO)
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) +
                          VALUE(' INPUT REVERSED.')
             GOTO       CMDLBL(@001)
             ENDDO

             IF         COND(&@KMK3 *EQ ' ' *AND &@KMK4 *NE ' ') +
                          THEN(DO)
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) +
                          VALUE(' INPUT REVERSED.')
             GOTO       CMDLBL(@001)
             ENDDO


             IF         COND(&@KMK2 *NE ' ' *AND &@KMK2 *NE '1' *AND +
                          &@KMK2 *NE '2' *AND &@KMK2 *NE '3') THEN(DO)
             CHGVAR     VAR(&IN05) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) +
                          VALUE(' REVERSED IS 1,2 OR 3.')
             GOTO       CMDLBL(@001)
             ENDDO

             IF         COND(&@KMK3 *NE ' ' *AND &@KMK3 *NE '1' *AND +
                          &@KMK3 *NE '2' *AND &@KMK3 *NE '3') THEN(DO)
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) +
                          VALUE(' REVERSED IS 1,2 OR 3.')
             GOTO       CMDLBL(@001)
             ENDDO

             IF         COND(&@KMK4 *NE ' ' *AND &@KMK4 *NE '1' *AND +
                          &@KMK4 *NE '2' *AND &@KMK4 *NE '3') THEN(DO)
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) +
                          VALUE(' REVERSED IS 1,2 OR 3.')
             GOTO       CMDLBL(@001)
             ENDDO

             IF         COND(&@KMK2 *NE ' ' *AND &@KMK3 *NE ' ') +
                          THEN(DO)
             IF         COND(&@KMK2 *EQ &@KMK3) THEN(DO)
             CHGVAR     VAR(&IN05) VALUE('1')
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) +
                          VALUE(' REVERSED IS DUPLICATED.')
             GOTO       CMDLBL(@001)
             ENDDO
             ENDDO

             IF         COND(&@KMK2 *NE ' ' *AND &@KMK4 *NE ' ') +
                          THEN(DO)
             IF         COND(&@KMK2 *EQ &@KMK4) THEN(DO)
             CHGVAR     VAR(&IN05) VALUE('1')
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) +
                          VALUE(' REVERSED IS DUPLICATED.')
             GOTO       CMDLBL(@001)
             ENDDO
             ENDDO

             IF         COND(&@KMK3 *NE ' ' *AND &@KMK4 *NE ' ') +
                          THEN(DO)
             IF         COND(&@KMK3 *EQ &@KMK4) THEN(DO)
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) +
                          VALUE(' REVERSED IS DUPLICATED.')
             GOTO       CMDLBL(@001)
             ENDDO
             ENDDO


             IF         COND(&IN11 *EQ '0') THEN(GOTO CMDLBL(@001))

             CHGVAR     VAR(&WSID) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(&FIL1) VALUE('GBFWP43' *CAT &WSID)
             CHGVAR     VAR(&FIL2) VALUE('GBF' *CAT &@TOKU *CAT &WKOJO)

             DLTF       FILE(&FIL1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL1) RCDLEN(100) +
                          TEXT('ﾌ]ﾌﾞbj]f ffﾞhfbmb vlyﾒWORKmﾞｰj  +
                          GBFXXXXX') OPTION(*NOLIST) SIZE(15000 +
                          1000 3) LVLCHK(*NO) AUT(*ALL)

             IF         (&@SYOKA *EQ '0') DO
             DLTF       FILE(&FIL2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL2) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(GBFNP44) TEXT('ﾌ]ﾌﾞbj]f ffﾞhfbmb +
                          vlyﾒmﾞｰj  GBFXXXXX') OPTION(*NOLIST +
                          *NOSRC) SIZE(15000 1000 3) LVLCHK(*NO) +
                          AUT(*ALL)
             ENDDO

             OVRDBF     FILE(GBFWP43) TOFILE(&FIL1)
             CALL       PGM(GBFR43) PARM(&@TOKU &@KOJO)

             OVRDBF     FILE(GBFNP44) TOFILE(&FIL2)

             CALL       PGM(GBFR44) PARM(&@SYOKA &@KMK1 &@KMK2 +
                          &@KMK3 &@KMK4)

             DLTF       FILE(&FIL1)
             DLTOVR     FILE(*ALL)

END:         ENDPGM
