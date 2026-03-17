             PGM
             /** ALDC91 **********************************************/
             /*        PICK-UP     LIST..                            */
             /*                  01.07.31                            */
             /********************************************** ALDC91 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SSID) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&DATE)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&DATX)  TYPE(*CHAR) LEN(6)
             DCLF       FILE(ALDPW91)

             RTVJOBA    JOB(&WSID) USER(&US) DATE(&DATE)
             CHGVAR     VAR(&D@DATE) VALUE(&DATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&US &WLIB)

             CHGVAR     VAR(&SSID) VALUE(%SUBSTRING(&WSID 1 3))
  @STRT:
             SNDRCVF    RCDFMT(ALDPW911)

             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&MSG) VALUE('           ')

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@END))

             IF         COND(&IN05 *EQ '1') THEN(DO)
             IF         COND(&D@DATE *EQ 0) THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('DATE ERROR')
             GOTO @STRT
             ENDDO


             OVRPRTF    FILE(QPRINT) FORMTYPE(K6H1)


             CHGVAR     VAR(&DATX) VALUE(&D@DATE)
             CALL       PGM(ALDR91) PARM(&DATX &HIN1 &HIN2 &HIN3)

             DLTOVR     FILE(*ALL)
             GOTO @END
             ENDDO

             GOTO       CMDLBL(@STRT)

 @END:       ENDPGM
