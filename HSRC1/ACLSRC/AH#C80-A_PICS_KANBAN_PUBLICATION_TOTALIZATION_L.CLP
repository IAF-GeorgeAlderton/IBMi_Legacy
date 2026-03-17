             PGM
             /*** AH#C80 *************************************/
             /* A-PICS KANBAN PUBLICATION TOTALIZATION LIST */
             /* SECTION CODE / DATE APPOINTMENT          */
             /*            K.OKACHI          98.10.26        */
             /************************************* AH#C80 ***/
             DCLF       FILE(AH#PW80)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PUS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             RTVJOBA    JOB(&WSID) USER(&PUS)
             CHGJOB     RUNPTY(40)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AH#PW801)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         COND(&PBMON *EQ '    ') THEN(DO)
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('SECTION CODE IS NOT INPUT.')
             GOTO STP1
             ENDDO

             IF         COND(&PBMON *NE '0111') THEN(DO)
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('SECTION CODES ARE 0111')
             GOTO STP1
             ENDDO

             IF         COND(&PYYMM *EQ '      ') THEN(DO)
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('REVERSING DATE IS NOT INPUT')
             GOTO STP1
             ENDDO

             IF         (&IN05 *EQ '0') GOTO STP1


             CHGVAR     VAR(&FILE1) VALUE('AH#WP80' *CAT &WS)
             CHGVAR     VAR(&FILE2) VALUE('AH#WP81' *CAT &WS)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             OVRDBF     FILE(AH#WP80) TOFILE(&FILE1)
             CALL       PGM(AH#R80) PARM(&PBMON &PYYMM)

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) SRCFILE(FMTSRC) +
                          SRCMBR(AH#S80) OPTION(*NOPRT)
             DLTF       FILE(&FILE1)

             OVRPRTF    FILE(AH#PR80) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          198) LPI(6) CPI(15) OVRFLW(60) +
                          RPLUNPRT(*YES) OUTQ(QPRINTC) +
                          FORMTYPE(K6H1) MAXRCDS(*NOMAX)
             OVRDBF     FILE(AH#WP81) TOFILE(&FILE2)
             CALL       PGM(AH#R81) PARM(&PBMON &PYYMM &PUS)
             DLTF       FILE(&FILE2)
             DLTOVR     FILE(*ALL)

 END:        CHGJOB     RUNPTY(20)

             ENDPGM
