             PGM
             /*** GBFC01 *************************/
             /*  WEIGHT TOTALIZATION LIST BY PART NUMBER */
             /*        H.ITO        87.11.10     */
             /************************* GBFC01 ***/
             DCLF       FILE(GBFPW01)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(GBFPW011)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         COND(&PTOKU *EQ '    ') THEN(DO)
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('CUSTOMER CODE IS NOT INPUT')
             GOTO STP1
             ENDDO

             IF         COND(&PNKOJ *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('REVERSING FACTORY IS NOT INPUT')
             GOTO STP1
             ENDDO

             IF         COND(&PKUBN *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('REVERSING INSTRUCTION IS NOT INPUT')
             GOTO STP1
             ENDDO

             IF         COND((&PKUBN *NE '1') *AND (&PKUBN *NE '2')) +
                          THEN(DO)
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('REVERSING INSTRUCTION  IS 1 OR 2')
             GOTO STP1
             ENDDO

             IF         (&IN05 *EQ '0') GOTO STP1

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 80) +
                          LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE('K6S1') IGCDTA(&PIGCD)
             CALL       PGM(GBFR01) PARM(&PTOKU &PNKOJ &PKUBN)
             DLTOVR     FILE(QPRINT)

 END:        ENDPGM
