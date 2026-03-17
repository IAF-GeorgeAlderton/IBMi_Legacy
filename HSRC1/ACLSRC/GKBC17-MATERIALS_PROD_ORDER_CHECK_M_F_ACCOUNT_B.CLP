             PGM
             /*** GKBC17 *********************************/
             /* MATERIALS PROD.    ORDER CHECK M/F ACCOUNT BOOK */
             /*         H.ITO          88.11.03          */
             /********************************* GKBC17 ***/
             DCLF       FILE(GKBPW17)
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
      /*     DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1) */
      /*     DCL        VAR(&MBAN)  TYPE(*CHAR) LEN(4) */
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WS)    USER(&USER)
             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
 STP1:       SNDRCVF    DEV(&WS)    RCDFMT(GKBPW171)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN02)  VALUE('0')
             CHGVAR     VAR(&IN99)  VALUE('0')
             CHGVAR     VAR(&PSIRE) VALUE('    ')
             CHGVAR     VAR(&PSU)   VALUE(1)

             IF         (&PNO *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT NO..')
             GOTO STP1
             ENDDO

             IF         COND((&PNO *NE '1') *AND (&PNO *NE '2') *AND +
                          (&PNO *NE '3')) THEN(DO)
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('NO. ISN')
             GOTO STP1
             ENDDO

             IF         (&PNO *EQ '2') GOTO @002
             IF         (&PNO *EQ '3') GOTO @003

             /****************************************************/
             /*LIST ABOUT M-NO1 COMPLETION MATERIAL ORDER        */
             /****************************************************/

 @001:       SNDRCVF    DEV(&WS) RCDFMT(GKBPW172)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN02 *EQ '1') DO
             CHGVAR     VAR(&PNO) VALUE(' ')
             GOTO STP1
             ENDDO

             IF         (&PSU *EQ 0) THEN(DO)
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT PUBLICATION NUMBER OF COPIES.')
             GOTO @001
             ENDDO

             IF         (&IN05 *EQ '0') GOTO @001
             CHGJOB     SWS(00000000)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          COPIES(&PSU) IGCDTA(&PIGCD)
             CALL       PGM(GKBR17) PARM(&USER)
             IF         (%SWITCH(1XXXXXXX)) DO
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THERE ARE NO DATA TO LIST.')
             GOTO @001
             ENDDO
             DLTOVR     FILE(QPRINT)
             GOTO       END

             /****************************************************/
             /*LIST ABOUT M-NO2 COMPLETION MATERIALS BY SUPPLIER  */
             /****************************************************/

 @002:       SNDRCVF    DEV(&WS) RCDFMT(GKBPW173)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN06) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN02 *EQ '1') DO
             CHGVAR     VAR(&PNO) VALUE(' ')
             GOTO STP1
             ENDDO

             IF         (&PSIRE *EQ '    ') THEN(DO)
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT SUPPLIER.')
             GOTO @002
             ENDDO

             IF         (&IN05 *EQ '0') GOTO @002
             CHGJOB     SWS(00000000)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(GKBR18) PARM(&USER &PSIRE)
             IF         (%SWITCH(1XXXXXXX)) DO
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THERE ARE NO DATA TO LIST.')
             GOTO @002
             ENDDO
             DLTOVR     FILE(QPRINT)
             GOTO       END

             /****************************************************/
             /*LIST ABOUT M-NO2 COMPLETION MATERIALS RECEIVING BY FACTORY */
             /****************************************************/

 @003:       SNDRCVF    DEV(&WS) RCDFMT(GKBPW174)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN06) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN02 *EQ '1') DO
             CHGVAR     VAR(&PNO) VALUE(' ')
             GOTO STP1
             ENDDO

             IF         (&PUKER *EQ '    ') THEN(DO)
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT RECEIVING FACTORY.')
             GOTO @003
             ENDDO

             IF         (&IN05 *EQ '0') GOTO @003
             CHGJOB     SWS(00000000)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(GKBR19) PARM(&USER &PUKER)
             IF         (%SWITCH(1XXXXXXX)) DO
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THERE ARE NO DATA TO LIST.')
             GOTO @003
             ENDDO
             DLTOVR     FILE(QPRINT)

 END:        ENDPGM
