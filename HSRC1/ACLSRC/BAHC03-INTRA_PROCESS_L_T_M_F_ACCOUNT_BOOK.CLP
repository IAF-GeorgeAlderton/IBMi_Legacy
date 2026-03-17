             PGM
             /** BAHC03 ************************/
             /* INTRA-PROCESS L / T M/F ACCOUNT BOOK */
             /* A.IDOTA 1994.11.15 */
             /************************ BAHC03 **/
             DCLF       FILE(BAHPW03)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&BMN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&PDEVT)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)  TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSID)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

 /* SCREEN CHECK */
 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(BAHPW031)
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(END))

   /*        IF         COND(&BMN *NE '8974' *AND &BMN *NE '8982' +
                          *AND &BMN *NE '8990' *AND &BMN *NE '9024' +
                          *AND &BMN *NE '9032' *AND &BMN *NE '9040' +
                          *AND &BMN *NE '9245' *AND &BMN *NE '9253' +
                          *AND &BMN *NE '9431' *AND &BMN *NE +
                          '9999') THEN(DO)                          */
             IF         COND(&BMN *NE '0111' *AND &BMN *NE '9999') +
                          THEN(DO)
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE INPUT OF SECTION IS +
                        NOT RIGHT.')
             GOTO       CMDLBL(STP1)
             ENDDO

             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(STP1))

 /* ACCOUNT BOOK CREATE */
 STP2:       OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) OVRFLW(60) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(BAHR03) PARM(&BMN)
             DLTOVR     FILE(QPRINT)

 END:        ENDPGM
