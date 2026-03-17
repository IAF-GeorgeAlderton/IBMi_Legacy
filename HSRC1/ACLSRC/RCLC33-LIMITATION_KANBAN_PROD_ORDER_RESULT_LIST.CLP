             PGM
             /** RCLC33 ************************************/
             /* ...LIMITATION KANBAN PROD.    ORDER RESULT LIST ... */
             /*        I-HASADA             84.08.01       */
             /************************************ RCLC33 **/
             DCLF       FILE(RCLPW33)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID) USER(&US)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(RCLPW331)
             IF         (&IN01 *EQ '1') RETURN

             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF       (&OLDYMD *EQ '      ') GOTO STP2
             IF       (%SUBSTRING(&OLDYMD 1 4) *LT '1982') GOTO STP3
             IF       (%SUBSTRING(&OLDYMD 5 2) *LT '01') GOTO STP3
             IF       (%SUBSTRING(&OLDYMD 5 2) *GT '12') GOTO STP3
             IF       (%SUBSTRING(&OLDYMD 7 2) *LT '01') GOTO STP3
             IF       (%SUBSTRING(&OLDYMD 7 2) *GT '31') GOTO STP3

             IF       (&NEWYMD *EQ '      ') GOTO STP4
             IF       (%SUBSTRING(&NEWYMD 1 4) *LT '1982') GOTO STP5
             IF       (%SUBSTRING(&NEWYMD 5 2) *LT '01') GOTO STP5
             IF       (%SUBSTRING(&NEWYMD 5 2) *GT '12') GOTO STP5
             IF       (%SUBSTRING(&NEWYMD 7 2) *LT '01') GOTO STP5
             IF       (%SUBSTRING(&NEWYMD 7 2) *GT '31') GOTO STP5

             IF       (&OLDYMD *GT &NEWYMD) GOTO STP6
             GOTO     STP7

 STP2:       IF       (&NEWYMD *EQ '      ') GOTO STP7
             IF       (%SUBSTRING(&NEWYMD 1 4) *LT '1982') GOTO STP5
             IF       (%SUBSTRING(&NEWYMD 5 2) *LT '01') GOTO STP5
             IF       (%SUBSTRING(&NEWYMD 5 2) *GT '12') GOTO STP5
             IF       (%SUBSTRING(&NEWYMD 7 2) *LT '01') GOTO STP5
             IF       (%SUBSTRING(&NEWYMD 7 2) *GT '31') GOTO STP5
             GOTO       STP7

 STP3:       CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE FIRST DATE BEING WRONG +
                        INPUT A RIGHT DATA')
             GOTO       STP1

 STP4:       CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE SECOND DATE  +
                        IS NOT INPUT,INPUT A RIGHT DATA')
             GOTO       STP1

 STP5:       CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE SECOND DATE BEING WRONG +
                        INPUT A RIGHT DATE')
             GOTO       STP1

 STP6:       CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE SECOND DATE IS SMALLER THAN THE +
                        FIRST DATE,CHECK IT')
             GOTO       STP1

 STP7:       CHGVAR     VAR(&IN04) VALUE('1')

             IF         (&IN05 *EQ '0') GOTO STP1

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRT) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(RCLR33) PARM(&OLDYMD &NEWYMD)
             DLTOVR     FILE(QPRINT)

             ENDPGM
