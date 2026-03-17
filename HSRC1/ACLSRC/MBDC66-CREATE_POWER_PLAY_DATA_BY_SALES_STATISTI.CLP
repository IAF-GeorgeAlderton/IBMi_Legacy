             PGM
             /** MBDC66********************************************/
             /*   納入統計ファイルよりパワープレイ用データ作成  */
             /*   C:N.HAYAKAWA                2000.08.30          */
             /*****************************************************/
             DCLF       FILE(MBDPW66)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID2) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(9)
             DCL        VAR(&TVTOK) TYPE(*CHAR) LEN(20)
             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&WSID2) VALUE(%SST(&WSID 1 2))
          /* CHGVAR     VAR(&FILE) VALUE('MBDWP66' *CAT %SST(&WSID +
                          1 2)) */
             CHGVAR     VAR(&FILE) VALUE('MBDWP66')

             /* MBDC66 実行中チェック */
             CHKOBJ     OBJ(MBDC66ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STEP03))
 STEP02:     SNDPGMMSG  MSG('( G +
                          )現在、他の端末でＰ／Ｐ用納入統計データ作+
                          成中。しばらく待て。') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         (&KOTAE *NE 'G') GOTO STEP02
             GOTO       END
 STEP03:     CRTDTAARA  DTAARA(HOBJ1/MBDC66ACT) TYPE(*CHAR) LEN(10) +
                          AUT(*ALL)
             /*画面表示と内容チェック*/
  STEP01:    RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&CRTHZ)
             SNDRCVF  DEV(&WSID) RCDFMT(MBDPW661)
             CHGVAR     VAR(&IN99) VALUE('0')
             IF         (&IN01 *EQ '1') GOTO END1
             CHGVAR     VAR(&TVTOK) VALUE(&TVTOK1 *CAT &TVTOK2 *CAT +
                          &TVTOK3 *CAT &TVTOK4 *CAT &TVTOK5)
             IF         COND(&TVTOK *EQ '                    ') +
                          THEN(DO)
                 CHGVAR     VAR(&IN99) VALUE('1')
                 GOTO  STEP01
             ENDDO

             IF         (&IN05 *EQ '0') GOTO STEP01

             /*ワークファイル作成*/
             DLTF       FILE(&FILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE) RCDLEN(256) TEXT('P/P +
                          納入統計') OPTION(*NOLIST) SIZE(400000 +
                          10000 20) LVLCHK(*NO) AUT(*ALL)
             /*Ｐ／Ｐ用データ作成*/
             OVRDBF     FILE(MBDWP66) TOFILE(HWFILE1/&FILE)
             CALL       PGM(MBDR66) PARM(&TVTOK1 &TVTOK2 &TVTOK3 +
                          &TVTOK4 &TVTOK5 &CRTHZ)
             DLTOVR     FILE(MBDWP66)
             /*Ｐ／Ｐ用データ転送メッセージ出力*/
 STEP04:     SNDPGMMSG  MSG('( G +
                          )Ｐ／Ｐ用納入統計データが作成されました。+
                          データ転送完了後、『Ｇ』で答えなさい。') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND(&KOTAE *EQ 'I') THEN(GOTO CMDLBL(END1))
             IF         COND(&KOTAE *EQ 'G') THEN(DLTF +
                          FILE(HWFILE1/&FILE))
             IF         COND(&KOTAE *EQ 'G') THEN(GOTO CMDLBL(END1))
             GOTO       STEP04
 END1:       DLTDTAARA  DTAARA(HOBJ1/MBDC66ACT)

  END:       ENDPGM
