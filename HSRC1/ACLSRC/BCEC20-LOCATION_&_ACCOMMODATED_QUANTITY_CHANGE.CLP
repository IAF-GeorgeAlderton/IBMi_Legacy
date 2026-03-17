             PGM
             /** BCEC20 ********************************/
             /* ..LOCATION & ACCOMMODATED QUANTITY CHANGE LIST .. */
             /*         I-HASADA           82.01.11    */
             /******************************** BCEC20 **/
             DCLF       FILE(FCEPW20)
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATE)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&US)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&PLIST) TYPE(*CHAR) LEN(1)
             CHGJOB     RUNPTY(40)  SWS(00000000)
             RTVJOBA    JOB(&WS)    USER(&US) NBR(&JOBNO)

             CALL       PGM(FCER26) PARM(&PHIZK)

 STP1:       SNDRCVF    DEV(&WS) RCDFMT(FCEPW201)
             IF         (&IN01 *EQ '1') RETURN
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&PHIZK *NE '        ') GOTO STP2
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('DATE < YYYYMMDD > ISN''T INPUT.')
             GOTO       STP1

 STP2:       IF         (%SUBSTRING(&PHIZK 1 4) *LT '1981') GOTO STP3
             IF         (%SUBSTRING(&PHIZK 5 2) *GT '12') GOTO STP3
             IF         (%SUBSTRING(&PHIZK 5 2) *LT '01') GOTO STP3
             IF         (%SUBSTRING(&PHIZK 7 2) *GT '31') GOTO STP3
             IF         (%SUBSTRING(&PHIZK 7 2) *LT '01') GOTO STP3
             GOTO       STP4

 STP3:       CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('DATE < YYYYMMDD > IS WRONG. +
                          INPUT RIGHT DATE.')
             GOTO       STP1

 STP4:       DLTF       FILE(HEN)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(FCEWP20)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(FCEWP22)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(HWFILE1/HEN) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO)
             CRTPF      FILE(HWFILE1/FCEWP20) RCDLEN(54) +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO)

             CALL       PGM(FCER20) PARM(&PHIZK &PLIST)

             IF         (%SWITCH(1XXXXXXX)) GOTO STP5
             DLTF       FILE(FCEWP20)
             GOTO       END

 STP5:       CRTPF      FILE(HWFILE1/FCEWP22) RCDLEN(54) +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO)

             FMTDTA     INFILE((HWFILE1/FCEWP20 FCEWP20)) +
                          OUTFILE(HWFILE1/FCEWP22 FCEWP22) +
                          SRCFILE(FMTSRC) SRCMBR(FCES22) OPTION(*NOPRT)
             DLTF       FILE(FCEWP20)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(QPRINT) FORMTYPE(K6H1) COPIES(1)
             CALL       PGM(BCER22) PARM(&PHIZK &PLIST)
             DLTF       FILE(FCEWP22)
             DLTOVR     FILE(QPRINT)

             IF         (%SWITCH(X1XXXXXX)) GOTO STP7
             IF         (%SWITCH(XX1XXXXX)) GOTO STP20
             GOTO       END

 STP20:      SNDPGMMSG  MSG('(G) THERE IS LOC CHG COMMUNICATION LIST+
                          ..<COME TO EDP SECTION>..PLAN SECTION') +
                          TOMSGQ(&WS) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         (&KOTAE = 'G') GOTO END
             GOTO       STP20

 STP7:       SNDPGMMSG  MSG('(G) THERE IS LOC CHG COMMUNICATION DISKETTE+
                          ..<COME TO EDP SECTION>..PLAN SECTION') +
                          TOMSGQ(&WS) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         (&KOTAE = 'G') GOTO STP11
             GOTO       STP7

 STP11:      SNDPGMMSG  MSG('( G.C ) HEN 19. SET LOCATION CHANGE +
                          COMMUNICATION DISKETTE.') +
                          TOMSGQ(QSYSOPR) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         (&KOTAE = 'G') GOTO STP8
             IF         (&KOTAE = 'C') RETURN
             GOTO       STP11

 STP8:       CLRDKT     DEV(QDKT) VOL(AOYAMA) CHECK(*NO)
             OVRDKTF    FILE(QDKT) VOL(AOYAMA) LABEL(HEN)
             CPYF       FROMFILE(HEN) TOFILE(QDKT) MBROPT(*REPLACE)

 STP9:       SNDPGMMSG  MSG('( G ) HEN 19. TAKE IT OUT.') +
                          TOMSGQ(QSYSOPR) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         (&KOTAE = 'G') GOTO STP10
             GOTO STP9

 STP10:      DLTOVR     FILE(QDKT)
 END:        DLTF       FILE(HEN)

             CHGJOB     RUNPTY(20)
             SIGNOFF
             ENDPGM
