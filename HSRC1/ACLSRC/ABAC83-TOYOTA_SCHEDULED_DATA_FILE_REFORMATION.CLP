             PGM        PARM(&WFILE &WLIBR &WNUKI &WSKRE &WSKHI)
             /** ABAC83 **************************************/
             /*  ..TOYOTA SCHEDULED DATA FILE REFORMATION..  */
             /*    I-HASADA                    2001.03.20    */
             /************************************** ABAC83 **/
             DCLF       FILE(ABAPW83)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WFILE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WLIBR) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WNUKI) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSKRE) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WSKHI) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WKTIM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WSTIM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WRECD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WKENS) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&PYM) VALUE(&WNUKI)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHKOBJ     OBJ(&WLIB/ABAC83ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(VTP1))

 VTP2:       SNDPGMMSG  MSG('( G ) OTHER MASTER FILES ARE BEING +
                          REORGANIZED. PLEASE WAIT FOR A WHILE. ') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +
                          THEN(GOTO CMDLBL(VTP2))
             GOTO       SEND

 VTP1:       CRTDTAARA  DTAARA(&WLIB/ABAC83ACT) TYPE(*CHAR) LEN(10) +
                          AUT(*ALL)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(ABAPW831)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR   VAR(&IN02) VALUE('0')
             CHGVAR   VAR(&IN99) VALUE('0')

             IF         (&PYM *EQ '        ') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DATE IS NOT INPUT.')
             GOTO       STP1
             ENDDO

             IF         (%SST(&PYM 1 4) *LT '1984') GOTO STP2
             IF         (%SST(&PYM 5 2) *GT '12') GOTO STP2
             IF         (%SST(&PYM 5 2) *LT '01') GOTO STP2
             IF         (%SST(&PYM 7 2) *GT '31') GOTO STP2
             IF         (%SST(&PYM 7 2) *LT '01') GOTO STP2
             GOTO       STP3
 STP2:       CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DATE IS NOT CORRECT.')
             GOTO       STP1

 STP3:       IF         (&IN05 *EQ '0') GOTO STP1
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WKTIM)

             CALL       PGM(ABAR83) PARM(&PYM &WRECD &WKENS)

             RGZPFM     FILE(ABAWP18)
             MONMSG     MSGID(CPF2981)
             RGZPFM     FILE(ABAWP21)
             MONMSG     MSGID(CPF2981)
             RGZPFM     FILE(ABAWP24)
             MONMSG     MSGID(CPF2981)
             RGZPFM     FILE(ABAWP27)
             MONMSG     MSGID(CPF2981)
             RGZPFM     FILE(ABAWP2A)
             MONMSG     MSGID(CPF2981)
             RGZPFM     FILE(ABAWP2D)
             MONMSG     MSGID(CPF2981)
             RGZPFM     FILE(ABAWP2G)
             MONMSG     MSGID(CPF2981)
             RGZPFM     FILE(ABAWP2M)
             MONMSG     MSGID(CPF2981)
             RGZPFM     FILE(ABAWP2P)
             MONMSG     MSGID(CPF2981)
             RGZPFM     FILE(ABAWP2Q)
             MONMSG     MSGID(CPF2981)
             RGZPFM     FILE(ABAWP2S)
             MONMSG     MSGID(CPF2981)
             RGZPFM     FILE(ABAWP20)
             MONMSG     MSGID(CPF2981)
             RGZPFM     FILE(ABAWP2R)
             MONMSG     MSGID(CPF2981)
             RGZPFM     FILE(ABAWP2T)
             MONMSG     MSGID(CPF2981)
             RGZPFM     FILE(ABAWP10)
             MONMSG     MSGID(CPF2981)

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WSTIM)
             CHGVAR     VAR(&WNUKI) VALUE(&PYM)

             CALL       PGM(VJBR14) PARM(&WFILE &WNUKI &WKTIM &WSTIM +
                          &WRECD &WKENS)

 END:        DLTDTAARA  DTAARA(&WLIB/ABAC83ACT)

 SEND:       ENDPGM
