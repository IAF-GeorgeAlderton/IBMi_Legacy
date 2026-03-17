             PGM
             /*** GKBC25 ***********************************/
             /* EACH FACTORY MATERIALS ADMISSION RESULTS TOTAL LIST CREATE */
             /*         H.ITO            88.10.03          */
             /*********************************** GKBC25 ***/
             DCLF       FILE(GKBPW25)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WS)    USER(&USER)

             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

 STP1:       SNDRCVF    DEV(&WS) RCDFMT(GKBPW251)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN06) VALUE('0')
             CHGVAR     VAR(&IN07) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&@YY *EQ '    ') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('APPOINTED DATE (YEAR) IS NOT INPUT.')
             GOTO STP1
             ENDDO

             IF         (&@MM *EQ '  ') DO
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('APPOINTED DATE (MONTH) IS NOT INPUT.')
             GOTO STP1
             ENDDO

             IF         (&@DD *EQ '  ') DO
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('OPERATION DATE IS NOT INPUT.')
             GOTO STP1
             ENDDO

             IF         (&@BMON *EQ '    ') DO
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('SECTION CODE IS NOT INPUT.')
             GOTO STP1
             ENDDO

             IF         COND((&@BMON *NE '0111') *AND +
                             (&@BMON *NE '9999')) THEN(DO)
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('SECTION CODE IS NOT RIGHT.')
             GOTO STP1
             ENDDO

             IF         (&@KUBN *EQ ' ') DO
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('MATERIALS INSTRUCTION IS NOT INPUT.')
             GOTO STP1
             ENDDO

             IF         ((&@KUBN *NE 'A') *AND (&@KUBN *NE 'B')) DO
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('MATERIALS INSTRUCTION IS NOT RIGHT.')
             GOTO STP1
             ENDDO

             IF         (&IN05 *EQ '0') GOTO STP1


             OVRPRTF    FILE(GKBPR25) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          80) LPI(6) OVRFLW(62) RPLUNPRT(*YES ' ') +
                          OUTQ(&PRTG) FORMTYPE(K6S1) IGCDTA(&PIGCD)

             CALL       PGM(GKBR25) PARM(&@YY &@MM &@DD &@BMON &@KUBN)
             DLTOVR     FILE(GKBPR25)

 END:        ENDPGM
