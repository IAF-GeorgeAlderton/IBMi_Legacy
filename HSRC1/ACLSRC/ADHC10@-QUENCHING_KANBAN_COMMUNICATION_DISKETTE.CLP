             PGM
             /** ADHC10 ************************************/
             /* QUENCHING KANBAN COMMUNICATION / DISKETTE PUBLICATION */
             /* A.IDOTA                   1995.05.15       */
             /************************************ ADHC10 **/
             DCLF       FILE(ADHPW10)
             DCL        VAR(&MCEDP01) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&HIZK) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FIL1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL3) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL4) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL5) TYPE(*CHAR) LEN(8)

             CHGJOB     SWS(00000000)
             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)
             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&HIZK) VALUE(%SUBSTRING(&MCEDP01 1 6))

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(ADHPW101)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         COND(&FNO *NE '1' *AND &FNO *NE '2' *AND +
                          &FNO *NE '3') THEN(DO)
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('SELECT NO. IS <1 2 3>')
             GOTO       STP1
             ENDDO

             IF         COND(&FNKOJ *NE '0111') THEN(DO)
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('FACTORY CODE IS 0111')
             GOTO       STP1
             ENDDO

             IF         (&FKB *NE '1' *AND &FKB *NE '2') DO
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('SELECT NO.<1 2>')
             GOTO       STP1
             ENDDO

             IF         COND(&FNO *NE '1') THEN(DO)
             IF         COND(&FKB *EQ '1') THEN(DO)
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('IT IS POSSIBLE TO DO +
                          DISKETTE PUBLICATION HANDLING')
             GOTO       STP1
             ENDDO
             ENDDO

 STP2:       IF         (&IN05 *EQ '0') GOTO STP1

             CHGVAR     VAR(&FIL1) VALUE('AAEWP' *CAT &FNKOJ *CAT '1')
             CHGVAR     VAR(&FIL2) VALUE('AAEWP' *CAT &FNKOJ *CAT '2')
             CHGVAR     VAR(&FIL3) VALUE('AAEWP' *CAT &FNKOJ)
             CHGVAR     VAR(&FIL4) VALUE('AAEWP' *CAT &FNKOJ *CAT '3')
             CHGVAR     VAR(&FIL5) VALUE('AAET' *CAT &FNKOJ)

             CALL       PGM(ADHR10) PARM(&FIL5 'C')

             IF         (%SWITCH(XXXXXXX1)) DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('DATA OF LAST TIME HAD NOT +
                          PROCESSED BY COMMUNICATION')
             GOTO       STP1
             ENDDO

             CALL       PGM(ADHR10) PARM(&FIL5 'H')

             DLTF       FILE(&FIL1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(TWFILE1/&FIL1) RCDLEN(512) +
                          OPTION(*NOLIST) SIZE(3000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(OUTPUT1) TOFILE(&FIL1)
             CALL       PGM(ADHR11) PARM(&FNO ' ' ' ' &FNKOJ)
             DLTOVR     FILE(OUTPUT1)

             IF         (%SWITCH(0XXXXXXX)) DO
             DLTF       FILE(&FIL1)
             CALL       PGM(ADHR10) PARM(&FIL5 'D')
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THERE ARE NOT PUBLICATION +
                          DATA')
             GOTO       STP1
             ENDDO

             DLTF       FILE(&FIL2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(TWFILE1/&FIL2) RCDLEN(512) +
                          OPTION(*NOLIST) SIZE(3000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             IF         COND(&FNO *NE '3') THEN(DO)
             FMTDTA     INFILE((&FIL1)) OUTFILE(&FIL2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AAES12) +
                          OPTION(*NOPRT)
             ENDDO

             IF         COND(&FNO *EQ '3') THEN(DO)
             FMTDTA     INFILE((&FIL1)) OUTFILE(&FIL2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AAES13) +
                          OPTION(*NOPRT)
             ENDDO

             DLTF       FILE(&FIL1)

             DLTF       FILE(&FIL3)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(&FIL4)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(TWFILE1/&FIL3) RCDLEN(512) +
                          OPTION(*NOLIST) SIZE(3000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             CRTPF      FILE(TWFILE1/&FIL4) RCDLEN(512) +
                          OPTION(*NOLIST) SIZE(3000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(OUTPUT1) TOFILE(&FIL2)
             OVRDBF     FILE(OUTPUT2) TOFILE(&FIL3)
             OVRDBF     FILE(OUTPUT3) TOFILE(&FIL4)
             CALL       PGM(ADHR12) PARM(&FNO &FKB &FNKOJ &HIZK)
             DLTF       FILE(&FIL2)
             DLTOVR     FILE(OUTPUT1)
             DLTOVR     FILE(OUTPUT2)
             DLTOVR     FILE(OUTPUT3)

             DLTF       FILE(&FIL5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(TWFILE1/&FIL5) RCDLEN(512) +
                          OPTION(*NOLIST) SIZE(3000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(OUTPUT1) TOFILE(&FIL4)
             OVRDBF     FILE(OUTPUT2) TOFILE(&FIL5)
             CALL       PGM(ADHR13)

             CALL       PGM(ADHR10) PARM(&FIL5 ' ')

         /*  DLTF       FILE(&FIL3) */
         /*  DLTF       FILE(&FIL4) */
             DLTOVR     FILE(OUTPUT1)
             DLTOVR     FILE(OUTPUT2)

             IF         (&FKB *NE '1') DO

 STEP01:     SNDPGMMSG  MSG('( G )  DUETO RELEASED DATA PRESENCE +
                          PROCESS KANBAN RELEASE WITH RELEASE PC. < +
                          CONFIRMATION OK - G >') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(STEP02))
             GOTO       STEP01

 STEP02:     CALL       PGM(ADHR10) PARM(&FIL5 'E')

             ENDDO

 END:        ENDPGM
