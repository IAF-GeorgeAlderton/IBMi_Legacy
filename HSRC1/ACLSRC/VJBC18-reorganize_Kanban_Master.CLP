             PGM        PARM(&WFILE &WLIBR &WNUKI &WSKRE &WSKHI)
             /** VJBC18 ********************************/
             /*   ...かんばんマスター　　再編成...   */
             /*       I-HASADA          87.10.30       */
             /******************************** VJBC18 **/
             DCLF       FILE(VJBPW18)
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
             DCL        VAR(&WSOUR) TYPE(*CHAR) LEN(8)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID)

             CHKOBJ     OBJ(VJBACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(VTP1))
 VTP2:       SNDPGMMSG  MSG('( G ) OTHER MASTER FILES ARE BEING +
                          REORGANIZED. PLEASE WAIT FOR A WHILE. ') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +
                          THEN(GOTO CMDLBL(VTP2))
             GOTO       SEND


/* VTP1:       CRTDTAARA  DTAARA(HFILE1/VJBACT) TYPE(*CHAR) LEN(10) +
                          TEXT('マスターファイル再編成') AUT(*ALL) */

 VTP1:       CRTDTAARA  DTAARA(VJBACT) TYPE(*CHAR) LEN(10) +
                          TEXT('マスターファイル再編成') AUT(*ALL)

             CALL       PGM(VJBR17) PARM(&WFILE &WFINM)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(VJBPW181)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR   VAR(&IN02) VALUE('0')
             CHGVAR   VAR(&IN03) VALUE('0')
             CHGVAR   VAR(&IN04) VALUE('0')
             CHGVAR   VAR(&IN99) VALUE('0')

             IF         (&WFILE *EQ '       ') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('物理ファイル名が、入力され+
                          ていない')
             GOTO       STP1
             ENDDO

             IF         (%SST(&WFILE 1 1) *EQ 'D') GOTO STP2
             IF         (%SST(&WFILE 1 1) *EQ 'M') GOTO STP2
             IF         (%SST(&WFILE 1 1) *EQ 'R') GOTO STP2
             IF         (%SST(&WFILE 1 1) *EQ 'F') GOTO STP2
             IF         (%SST(&WFILE 1 1) *EQ 'T') GOTO STP2
             IF         (%SST(&WFILE 1 1) *EQ 'U') GOTO STP2
             IF         (%SST(&WFILE 1 1) *EQ 'E') GOTO STP2
             IF         (%SST(&WFILE 1 1) *EQ 'N') GOTO STP2
             IF         (%SST(&WFILE 1 1) *EQ 'K') GOTO STP2
             IF         (%SST(&WFILE 1 1) *EQ 'G') GOTO STP2
             IF         (%SST(&WFILE 1 1) *EQ 'S') GOTO STP2
             IF         (%SST(&WFILE 1 1) *EQ 'V') GOTO STP2
             IF         (%SST(&WFILE 1 1) *EQ 'A') GOTO STP2
             IF         (%SST(&WFILE 1 1) *EQ 'B') GOTO STP2
             IF         (%SST(&WFILE 1 1) *EQ 'C') GOTO STP2
             IF         (%SST(&WFILE 1 1) *EQ 'O') GOTO STP2
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('物理ファイル名は、< +
                          D､M､R､F､T､U､E､N､K､G､S､V､A､B､C､O >')
             GOTO       STP1

  STP2:      IF         (%SST(&WFILE 4 2) *EQ 'PP') GOTO STP3
             IF         (%SST(&WFILE 4 2) *EQ 'WP') GOTO STP3
             IF         (%SST(&WFILE 4 2) *EQ 'TP') GOTO STP3
             IF         (%SST(&WFILE 4 2) *EQ 'NP') GOTO STP3
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('物理ファイル名４・５桁目は+
                          、< PP､TP､WP､NP >')
             GOTO       STP1

 STP3:       IF         (%SST(&WNUKI 1 4) *LT '1997') GOTO STP4
             IF         (%SST(&WNUKI 5 2) *GT '12') GOTO STP4
             IF         (%SST(&WNUKI 5 2) *LT '01') GOTO STP4
             IF         (%SST(&WNUKI 7 2) *GT '31') GOTO STP4
             IF         (%SST(&WNUKI 7 2) *LT '01') GOTO STP4
             GOTO       STP5
 STP4:       CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('日付が、正しくない')
             GOTO       STP1

 STP5:       IF         (&WSKHI *EQ '   ') DO
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('削除コードの位置が、入力さ+
                          れていない')
             GOTO       STP1
             ENDDO

             IF         (&IN05 *EQ '0') GOTO STP1

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WKTIM)

             CHGVAR     VAR(&WSOUR) VALUE('ADDSSRC')

             CHGVAR     VAR(&LIB) VALUE('HSRC1   ')

             GOTO       @EX

 VTP19:      SNDPGMMSG  MSG('( D､T､I､C ) ' *CAT &WFILE *CAT ' ﾎｦbﾓ ﾉ +
                          ﾌﾞｮhaｮﾎﾟ D､>mﾞｧﾇiｮn <2D> ujﾝ T､>m-ﾎﾟ ･ +
                          fioﾅb') TOMSGQ(QSYS/QSYSOPR) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF       (&KOTAE *EQ 'T') GOTO STP7
             IF       (&KOTAE *EQ 'I') GOTO @EX
             IF       (&KOTAE *EQ 'C') GOTO END
             GOTO       VTP19

 STP7:       INZTAP     DEV(TAP01) NEWVOL(IAF) CHECK(*NO) +
                          DENSITY(*ULTRIUM6)
             SAVOBJ     OBJ(&WFILE) LIB(&WLIBR) DEV(TAP01) +
                          OBJTYPE(*FILE) VOL(IAF) ENDOPT(*UNLOAD) +
                          ACCPTH(*YES)

 @EX:        DLTF       FILE(VJBWP18)
             MONMSG     MSGID(CPF3261 CPF2105)
/*           CRTPF      FILE(HWFILE1/VJBWP18) SRCFILE(&LIB/&WSOUR) +
                          SRCMBR(&WFILE) OPTION(*NOLIST *NOSRC) +
                          SIZE(30000 10000 9) LVLCHK(*NO) AUT(*ALL) */

             CRTPF      FILE(VJBWP18) SRCFILE(&LIB/&WSOUR) +
                          SRCMBR(&WFILE) OPTION(*NOLIST *NOSRC) +
                          SIZE(30000 10000 9) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(INPUT) TOFILE(&WFILE)
             CALL       PGM(VJBR18) PARM(&WNUKI &WRECD &WKENS &WSKHI +
                          &WFILE)
             DLTOVR     FILE(INPUT)

             CPYF       FROMFILE(VJBWP18) TOFILE(&WFILE) +
                          MBROPT(*REPLACE) FMTOPT(*MAP)
             MONMSG     MSGID(CPF2817)
             DLTF       FILE(VJBWP18)

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WSTIM)

             CALL       PGM(VJBR14) PARM(&WFILE &WNUKI &WKTIM &WSTIM +
                          &WRECD &WKENS)

 END:        DLTDTAARA  DTAARA(VJBACT)

 SEND:       ENDPGM
