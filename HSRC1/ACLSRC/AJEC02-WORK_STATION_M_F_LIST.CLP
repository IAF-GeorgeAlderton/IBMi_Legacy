             PGM
             /** AJEC02 **********************************/
             /* WORK STATION M/F LIST                    */
             /*              A.IDOTA 89.02.17            */
             /********************************** AJEC02 **/
             DCLF       FILE(AJEPW02)
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

      /* SCREEN CHECK */

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AJEPW021)
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&IN02) VALUE('0')
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(END))

             IF         COND(&@KUB *NE 1 *AND &@KUB *NE 2 *AND &@KUB +
                          *NE 3 *AND &@KUB *NE 4) THEN(DO)
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('PUBLICATION INSTRUCTION IS +
                          <1,2,3,4>.')
             GOTO       CMDLBL(STP1)
             ENDDO

             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(STP1))

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD)

      /* WS-NO ORDER */

             IF         COND(&@KUB *EQ 1 *OR &@KUB *EQ 4) THEN(DO)
             CALL       PGM(AJER02)
             ENDDO

      /* CONTROL DEVICE. ADDRESS ORDER */

             IF         COND(&@KUB *EQ 2 *OR &@KUB *EQ 4) THEN(DO)
             CALL       PGM(AJER09)
             ENDDO

      /* SETUP DEPARTMENT ORDER */

             IF         COND(&@KUB *EQ 3 *OR &@KUB *EQ 4) THEN(DO)
             CALL       PGM(AJER10)
             ENDDO

             DLTOVR     FILE(QPRINT)

 END:        ENDPGM
