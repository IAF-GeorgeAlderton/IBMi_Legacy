             PGM
             /** RCLC82 ************************/
             /*NON ARRIVAL INVESTIGATION LIST */
             /* I-HASADA 84.07.26 */
             /************************ RCLC82 **/
             DCLF       FILE(RCLPW82) RCDFMT(RCLPW821)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CHGJOB     SWS(00000000)
             CHGVAR     VAR(&PKUBN) VALUE('Y')

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(RCLPW821)
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO END
             IF         (&PHIZK *NE '        ') GOTO STP2
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT DATE  ')
             GOTO       STP1

 STP2:       IF         (%SUBSTRING(&PHIZK 1 4) *LT '1981') GOTO STP3
             IF         (%SUBSTRING(&PHIZK 5 2) *LT '01') GOTO STP3
             IF         (%SUBSTRING(&PHIZK 5 2) *GT '12') GOTO STP3
             IF         (%SUBSTRING(&PHIZK 7 2) *LT '01') GOTO STP3
             IF         (%SUBSTRING(&PHIZK 7 2) *GT '31') GOTO STP3
             GOTO       STP4

 STP3:       CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('DATE ( YYMMDD ) ISNT RIGHT')
             GOTO       STP1

 STP4:       IF         (&PKUBN *EQ 'N') GOTO STP5
             IF         (&PKUBN *EQ 'Y') GOTO STP5
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INSTRUCTION ( Y/N )')
             GOTO       STP1

 STP5:       IF         (&IN05 *EQ '1') GOTO STP7
             GOTO       STP1

 STP7:       DLTF       FILE(RCLWP82)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/RCLWP82) RCDLEN(220) +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO)

             CALL       PGM(RCLR82) PARM(&PKUBN &PHIZK)
             IF         (%SWITCH(1XXXXXXX)) GOTO STP6
             DLTF       FILE(RCLWP82)
             GOTO       END

 STP6:       DLTF       FILE(RCLWP83)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/RCLWP83) RCDLEN(220) +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO)

             FMTDTA     INFILE((RCLWP82)) OUTFILE(RCLWP83) +
                          SRCFILE(FMTSRC) SRCMBR(RCLS82) +
                          OPTION(*NOPRT)
             DLTF       FILE(RCLWP82)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRT) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(RCLR83) PARM(&PKUBN &PHIZK)
             DLTF       FILE(RCLWP83)
             DLTOVR     FILE(QPRINT)

 END:        ENDPGM
