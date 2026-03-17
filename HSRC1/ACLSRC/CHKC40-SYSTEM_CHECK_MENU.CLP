             PGM
             /** CHKC40 **************************/
             /*  SYSTEM CHECK MENU               */
             /*           K.YASUDA   2002.10.22  */
             /************************** CHKC40 **/
             DCLF       FILE(CHKPW40)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WS)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             RTVNETA    SYSNAME(&WSYS)
 INZ1:       CHGVAR     VAR(&@NO) VALUE(0)
 SCR1:       SNDRCVF  DEV(&WS) RCDFMT(CHKPW401)
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&MSG) +
                          VALUE('                                     -
                       ')
             IF         (&IN01 *EQ '1') GOTO EXIT

             IF         (&@NO *EQ 0) THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE(' PLEASE INPUT MENU NUMBER.')
             GOTO       SCR1
             ENDDO

             IF         COND(&@NO *EQ 10) THEN(GOTO CMDLBL(STPA))

             IF         COND((&@NO *NE 2) *AND (&@NO *NE 3) +
                        *AND (&@NO *NE 4)) THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('MENU NUMBER IS 2 TO 4.')
             GOTO       SCR1
             ENDDO

             IF         COND(&@NO *EQ 2) THEN(GOTO CMDLBL(STP2))
             IF         COND(&@NO *EQ 3) THEN(GOTO CMDLBL(STP3))
             IF         COND(&@NO *EQ 4) THEN(GOTO CMDLBL(STP4))


 STP2:       WRKDSKSTS
             GOTO       CMDLBL(INZ1)

 STP3:       WRKDSTQ
             GOTO       CMDLBL(INZ1)

 STP4:       WRKNETF    USER(*ALL)
             GOTO       CMDLBL(INZ1)

 STPA:       WRKPRB
             GOTO       CMDLBL(INZ1)

 EXIT:       ENDPASTHR
             MONMSG     MSGID(CPF8914)

             ENDPGM
