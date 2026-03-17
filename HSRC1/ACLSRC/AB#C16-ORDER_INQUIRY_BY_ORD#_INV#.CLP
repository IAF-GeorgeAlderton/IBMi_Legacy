             PGM
/** AB#C16 ************************************************/
/*  ORDER INQUIRY BY INV#/ORD#                            */
/*  J.WATANABE  2020.04.27                                */
/*----------------------------------------------          */
/*  JW1      2025.03.27 ADD AB#R12I (UNIVERSAL EDI INQ)   */
/**********************************************************/
             DCLF       FILE(AB#PW160)
             DCL        VAR(&US)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&US)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 STEP1:      CHGVAR     VAR(&XOPT) VALUE(' ')
             CHGVAR     VAR(&IN01) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN09) VALUE('0')
             CHGVAR     VAR(&IN12) VALUE('0')

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(DSP01)

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(ENDP))
             IF         COND(&IN03 *EQ '1') THEN(GOTO CMDLBL(ENDP))
             IF         COND(&IN12 *EQ '1') THEN(GOTO CMDLBL(ENDP))

             IF         COND(&IN09 *EQ '1') THEN(DO)
             CALL       PGM(AB#R99B)
             GOTO       STEP1
             ENDDO

             IF         COND(&XOPT *EQ '1') THEN(CALL PGM(AB#R161))

             IF         COND(&XOPT *EQ '2') THEN(CALL PGM(AB#R162))

             IF         COND(&XOPT *EQ '3') THEN(CALL PGM(AB#R163))

             IF         COND(&XOPT *EQ '4') THEN(CALL PGM(AB#C1O ))

             IF         COND(&XOPT *EQ '5') THEN(CALL PGM(ALDC01 ))

             IF         COND(&XOPT *EQ '6') THEN(CALL PGM(AB#R12I))

             CHGVAR     VAR(&XOPT) VALUE(' ')
             GOTO       CMDLBL(STP1)

 ENDP:       ENDPGM
