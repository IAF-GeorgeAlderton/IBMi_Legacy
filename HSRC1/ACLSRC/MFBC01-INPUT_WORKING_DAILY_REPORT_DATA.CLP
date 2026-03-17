             PGM
             /** MFBC01 ************************/
             /* INPUT WORKING DAILY REPORT DATA */
             /* A-IDOTA 1989.10.25 */
             /************************ MFBC01 **/
             DCLF       FILE(MFBPW42)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&IN01) TYPE(*LGL) LEN(1)
             DCL        VAR(&IN99) TYPE(*LGL) LEN(1)
             DCL        VAR(&@NO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG) TYPE(*CHAR)  LEN(60)
             RTVJOBA    JOB(&WS) USER(&US)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

 STP0:       CHGVAR     VAR(&@NO) VALUE(' ')
             SNDRCVF    DEV(&WS) RCDFMT(MFBPW421)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&@NO *EQ '1') GOTO STP1
             IF         (&@NO *EQ '2') GOTO STP2
             IF         (&@NO *EQ ' ') GOTO STP3
             CHGVAR     VAR(&IN01) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('INPUT  SELECT NO JUSTLY. .')
             GOTO       STP0
 STP3:       CHGVAR     VAR(&IN01) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) +
                          VALUE('INPUT SELECT NO.')
             GOTO       STP0

 STP1:       CALL       PGM(MFBR01) PARM(&US)
             GOTO       END

 STP2:       CALL       PGM(MFBR40) PARM(&US)
             GOTO       END

 END:        ENDPGM
