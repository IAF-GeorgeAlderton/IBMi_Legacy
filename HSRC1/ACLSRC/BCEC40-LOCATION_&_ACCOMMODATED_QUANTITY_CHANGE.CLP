             PGM
             /*** BCEC40 *************************************/
             /*   所番地＆収容数　変更リスト               */
             /*  CONTROL LANGUAGE :  BCEC40     <CL>         */
             /*  CREATE DATE.     :  APRIL,15,1994           */
             /*  AUTHOR.          :  SHINICHIRO.OHTAKE       */
             /*  USER SECTION.    :  PRODUCTION CONTROL      */
             /************************************* BCEC40 ***/
             DCLF       FILE(FCEPW40)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&CODE)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PHIZK) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PB1)   TYPE(*DEC)  LEN(2)
             DCL        VAR(&PB2)   TYPE(*DEC)  LEN(2)
             DCL        VAR(&PB3)   TYPE(*DEC)  LEN(2)
             DCL        VAR(&PTKST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PTKRA) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PTKRB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&US)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&PLIST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE3) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE4) TYPE(*CHAR) LEN(9)
             CHGJOB     RUNPTY(40) SWS(00000000)
             RTVJOBA    JOB(&WS) USER(&US) NBR(&JOBNO)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             CHGVAR     VAR(&CODE) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(&FILE1)  VALUE(&CODE *CAT 'HEN')
             CHGVAR     VAR(&FILE2)  VALUE(&CODE *CAT 'HEN2')
             CHGVAR     VAR(&FILE3)  VALUE(&CODE *CAT 'FCEWP20')
             CHGVAR     VAR(&FILE4)  VALUE(&CODE *CAT 'FCEWP22')

             CALL       PGM(BCER26) PARM(&PHIZK)


             CHGVAR     VAR(&PB1) VALUE('01')
             CHGVAR     VAR(&PB2) VALUE('01')
             CHGVAR     VAR(&PB3) VALUE('01')
 STP1:       SNDRCVF    DEV(&WS) RCDFMT(FCEPW401)
             IF         (&IN01 *EQ '1') RETURN
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN09) VALUE('0')
             CHGVAR     VAR(&IN06) VALUE('0')
             CHGVAR     VAR(&IN07) VALUE('0')
             CHGVAR     VAR(&IN08) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(%SUBSTRING(&PTKRA 1 1)) VALUE(&PTKR1)
             CHGVAR     VAR(%SUBSTRING(&PTKRA 2 2)) VALUE(&PTKR2)
             CHGVAR     VAR(%SUBSTRING(&PTKRA 4 2)) VALUE(&PTKR3)
             CHGVAR     VAR(%SUBSTRING(&PTKRA 6 1)) VALUE(&PTKR4)
             CHGVAR     VAR(%SUBSTRING(&PTKRB 1 1)) VALUE(&PTKR5)
             CHGVAR     VAR(%SUBSTRING(&PTKRB 2 2)) VALUE(&PTKR6)
             CHGVAR     VAR(%SUBSTRING(&PTKRB 4 2)) VALUE(&PTKR7)
             CHGVAR     VAR(%SUBSTRING(&PTKRB 6 1)) VALUE(&PTKR8)

             IF         (&PHIZK *NE '        ') GOTO STP2
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DATE HAS NOT BEEN INPUT.')
             GOTO       STP1

 STP2:       IF         (%SUBSTRING(&PHIZK 1 4) *LT '1981') GOTO STP3
             IF         (%SUBSTRING(&PHIZK 5 2) *GT '12') GOTO STP3
             IF         (%SUBSTRING(&PHIZK 5 2) *LT '01') GOTO STP3
             IF         (%SUBSTRING(&PHIZK 7 2) *GT '31') GOTO STP3
             IF         (%SUBSTRING(&PHIZK 7 2) *LT '01') GOTO STP3
             GOTO       STP4

 STP3:       CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DATE IS INCORRECT, +
                          INPUT THE RIGHT ONE.')
             GOTO       STP1

 STP4:       IF         (&PB2 *EQ 0)  GOTO STP5
             GOTO       STP6

 STP5:       IF         (&PB3 *NE 0)  GOTO STP6
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN09) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE NUMBER HAS NOT BEEN +
                          INPUT.')
             GOTO       STP1

 STP6:       IF         (&PTKST *NE ' ')  GOTO STP7
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE SPECIFICATION HAS NOT +
                          BEEN DONE.')
             GOTO       STP1

 STP7:       IF         (&PTKST *EQ 'Y')  GOTO STP9

 STP8:       IF         (&PTKST *EQ 'N')  GOTO STP9C
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('SPESIFY EITHER Y OR N')
             GOTO       STP1

 STP9C:      IF         (&PTKRA *EQ '      ')  GOTO STP9D
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('UNABLE TO INPUT WITH THE N +
                          SPECIFICATION.')
             GOTO       STP1

 STP9D:      IF         (&PTKRB *EQ '      ')  GOTO STP9A
             CHGVAR     VAR(&IN08) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('UNABLE TO INPUT WITH THE +
                          N SPECIFICATION.')
             GOTO       STP1

 STP9:       IF         (&PTKRA *NE '      ')  GOTO STP8A
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE LOCATION CODE +
                          SPECIFICATION IS IN CORRECT.')
             GOTO       STP1

 STP8A:      IF         (&PTKRB *NE '      ')  GOTO STP8B
             CHGVAR     VAR(&IN08) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE LOCATION CODE SPECIFIED +
                          IS IN CORRECT')
             GOTO       STP1

 STP8B:      IF         (&PTKRA *LE &PTKRB)  GOTO STP9A
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE LOCATION CODE SPECIFIED +
                          IS IN CORRECT')
             GOTO       STP1

 STP9A:      IF         (&IN05 *EQ '0') GOTO STP1

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(&FILE3)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(&FILE4)
             MONMSG     MSGID(CPF3261 CPF2105)


             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO)
             CRTPF      FILE(HWFILE1/&FILE3) RCDLEN(64) +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO)

             OVRDBF     FILE(HEN)     TOFILE(&FILE1)
             OVRDBF     FILE(FCEWP20) TOFILE(&FILE3)

             CALL       PGM(BCER20) PARM(&PHIZK &PLIST)

             IF         (%SWITCH(1XXXXXXX)) GOTO STP10
             DLTF       FILE(&FILE3)
             GOTO       STP20

 STP10:      CRTPF      FILE(HWFILE1/&FILE4) RCDLEN(64) +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO)

             OVRDBF     FILE(FCEWP22) TOFILE(&FILE4)

             FMTDTA     INFILE((HWFILE1/&FILE3)) +
                          OUTFILE(HWFILE1/&FILE4) SRCFILE(FMTSRC) +
                          SRCMBR(FCES22) OPTION(*NOPRT)
             DLTF       FILE(&FILE3)

             OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QPRINTA) FORMTYPE(K6H1)
             CALL       PGM(BCER22) PARM(&PHIZK &PLIST &US)
             DLTF       FILE(&FILE4)

 STP20:      CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO)

             OVRDBF     FILE(HEN2)    TOFILE(&FILE2)

             CALL       PGM(BCER43) PARM(&PHIZK &PLIST &PTKST &PTKRA +
                            &PTKRB)

             IF         (%SWITCH(XXX1XXXX)) GOTO STP30
             DLTF       FILE(&FILE2)
             GOTO       END


 STP30:      FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) SRCFILE(FMTSRC) +
                          SRCMBR(BCES40) OPTION(*NOPRT)

             DLTF       FILE(&FILE1)

             /*************************************/
             /*     所番地変更リスト (K6H1)     */
             /*************************************/

             IF         (&PB3 *EQ 0)  GOTO SKIP

             OVRPRTF    FILE(BCEPR41) DEVTYPE(*AFPDS) LPI(6) +
                          OVRFLW(63) RPLUNPRT(*YES) OUTQ(QPRINTA) +
                          FORMTYPE(K6H1) COPIES(&PB3)

             CALL       PGM(BCER41)

             /*************************************/
             /*     所番地変更リスト (K6S1)     */
             /*************************************/

 SKIP:       IF         (&PB2 *EQ 0) GOTO STP40

             OVRPRTF    FILE(BCEPR42) DEVTYPE(*AFPDS) LPI(6) +
                          OVRFLW(66) RPLUNPRT(*YES) OUTQ(QPRINTA) +
                          FORMTYPE(K6S1) COPIES(&PB2)

             CALL       PGM(BCER42)

 STP40:      CHGMSGQ    MSGQ(&WS) DLVRY(*BREAK)

             SNDPGMMSG  MSG('( G ) THERE IS THE CORRECTION LIST FOR +
                          LOCATION CODES.  < G-ENTER >') +
                          TOMSGQ(&WS) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       STP40


 END:        ENDPGM
