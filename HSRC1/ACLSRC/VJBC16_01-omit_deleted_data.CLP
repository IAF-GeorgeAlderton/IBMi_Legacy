             PGM        PARM(&WFILE &WLIBR &WNUKI &WSKRE &WSKHI)
             /** VJBC16 ************************************/
             /*   ..物理ファイル　削除データオミット..   */
             /*       I-HASADA              87.10.30       */
             /************************************ VJBC16 **/
             DCLF       FILE(VJBPW16)
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
             DCL        VAR(&WLB) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID)

             CHKOBJ     OBJ(VJBACT1) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(VTP1))

 VTP2:       SNDPGMMSG  MSG('( G )  +
                          他のマスターファイルを再編成中です。しば+
                          らくお待ち下さい。') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         (&KOTAE *NE 'G') GOTO VTP2
             GOTO       SEND

 VTP1:       CRTDTAARA  DTAARA(HFILE1/VJBACT1) TYPE(*CHAR) LEN(10) +
                          TEXT('マスターファイル再編成') AUT(*ALL)

             CALL       PGM(VJBR17) PARM(&WFILE &WFINM)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(VJBPW161)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR   VAR(&IN02) VALUE('0')
             CHGVAR   VAR(&IN03) VALUE('0')
             CHGVAR   VAR(&IN04) VALUE('0')
             CHGVAR   VAR(&IN06) VALUE('0')
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
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('物理ファイル名は、< +
                          D､M､R､F､T､U､E､N､K､G､S､V､A >')
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

 STP5:       IF         (&WSKRE *EQ '   ') DO
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('削除コードの位置が、入力さ+
                          れていない')
             GOTO       STP1
             ENDDO

             IF         (&WSKHI *EQ '   ') DO
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('削除予定の開始位置が、入力+
                          されていない')
             GOTO       STP1
             ENDDO

             IF         (&IN05 *EQ '0') GOTO STP1

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WKTIM)

             CHGVAR     VAR(&WSOUR) VALUE('ADDSSRC')

             CHGVAR     VAR(&WLB) VALUE('HSRC1   ')

             GOTO       STP9

 VTP191:     SNDPGMMSG  MSG('( D､T､I､C ) ' *CAT &WFILE *CAT ' ﾎｦbﾓ ﾉ +
                          ﾌﾞｮhaｮﾎﾟ D､>mﾞｧﾇiｮn <2D> ･ S123 ujﾝ +
                          T､>m-ﾎﾟ ･ fioﾅb') TOMSGQ(QSYS/QSYSOPR) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF       (&KOTAE *EQ 'T') GOTO STP7
             IF       (&KOTAE *EQ 'I') GOTO STP9
             IF       (&KOTAE *EQ 'C') GOTO END
             GOTO       VTP191

 STP7:       INZTAP     DEV(TAP01) NEWVOL(IAF) CHECK(*NO) +
                          DENSITY(*ULTRIUM6)
             SAVOBJ     OBJ(&WFILE) LIB(&WLIBR) DEV(TAP01) +
                          OBJTYPE(*FILE) VOL(IAF) ENDOPT(*UNLOAD) +
                          ACCPTH(*YES)

 STP8:       SNDPGMMSG  MSG('( G ) ' *CAT &WFILE *CAT ' ﾎｦbﾓ ﾉ +
                          ﾌﾞｮhaｮﾎﾟ mﾞｧﾇiｮn ujﾝ m-ﾎﾟ ･ ﾌﾇﾞﾈ') +
                          TOMSGQ(QSYS/QSYSOPR) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF       (&KOTAE *NE 'G') GOTO STP8

 STP9:       DLTF       FILE(VJBWP16)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/VJBWP16) SRCFILE(&WLB/&WSOUR) +
                          SRCMBR(&WFILE) TEXT('ﾎabﾓ ﾅbs]ﾈb mﾞ-j') +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(INPUT) TOFILE(&WFILE)
             CALL       PGM(VJBR16) PARM(&WNUKI &WRECD &WKENS &WSKRE +
                          &WSKHI)
             DLTOVR     FILE(INPUT)

             CLRPFM     FILE(&WFILE)
             CPYF       FROMFILE(VJBWP16) TOFILE(&WFILE) +
                          MBROPT(*REPLACE) FMTOPT(*MAP)
             DLTF       FILE(VJBWP16)

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WSTIM)

             CALL       PGM(VJBR14) PARM(&WFILE &WNUKI &WKTIM &WSTIM +
                          &WRECD &WKENS)

 END:        DLTDTAARA  DTAARA(VJBACT1)

 SEND:       ENDPGM
