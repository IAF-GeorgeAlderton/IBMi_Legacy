             PGM
             /** ABHC41 ******************************/
             /*工程内かんばんＭから必要情報の抽出  */
             /*       M-OKUDA      03.03.11          */
             /****************************** ABHC41 **/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DUS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(5)
             RTVJOBA    JOB(&WSID) USER(&US)
             CHGVAR     VAR(&FILE1) VALUE(%SUBSTRING(&US 1 5))
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHKOBJ     OBJ(ABHACT41) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STEP04))
             RTVDTAARA  DTAARA(FILELIB/ABHACT41 (1 10)) RTNVAR(&DUS)
             IF         (&US *EQ &DUS) DO
             DLTDTAARA  DTAARA(FILELIB/ABHACT41)
             MONMSG     MSGID(CPF2105 CPF9999)
             GOTO STEP04
             ENDDO
 STEP05:     SNDPGMMSG  MSG('( G ) このメニューは' *CAT &DUS +
                          *CAT +
                          'の作業者が処理中なので１０分程待って下+
                          さい。') TOMSGQ(&WSID) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         (&KOTAE *EQ 'G') GOTO END
             IF         (&US *EQ 'D6002     ') DO
             IF         (&KOTAE *EQ 'D') GOTO STEP99
             ENDDO
             GOTO       STEP05

 STEP04:     CRTDTAARA  DTAARA(FILELIB/ABHACT41) TYPE(*CHAR) LEN(10) +
                          VALUE(&US) +
                          TEXT('工程内かんばんからパソコン転送デー+
                          タ作成処理')
             /* 部品情報マスター選択後のデータ作成*/
             CLRPFM     FILE(ABHPP41)
             MONMSG     MSGID(CPF3261 CPF2105)
             CHGJOB     SWS(00000000)

             CALL       PGM(ABHR41)
             IF         (%SWITCH(1XXXXXXX)) GOTO STEP99
             IF         (%SWITCH(X1XXXXXX)) GOTO STEP00
             GOTO STEP01
 STEP00:     SNDPGMMSG  MSG('( G ) +
                          指定された条件に合致したデータは１件も有+
                          りませんでした。Ｇを選択すると終了します+
                          。') TOMSGQ(&WSID) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         (&KOTAE = 'G') GOTO STEP99
             GOTO       STEP00

             /* ＤＤＳのフィールド選択ＳＯＵＲＣＥの作成 */
 STEP01:     OVRDBF     FILE(INPUT) TOFILE(FILELIB/PCSOURCE) +
                          MBR(ABHPP42) POSITION(*START)
             CLRPFM     FILE(ABHPP43)
             MONMSG     MSGID(CPF3261 CPF2105)
             OVRDBF     FILE(OUTPUT) TOFILE(ABHPP43) POSITION(*START)
             CALL       PGM(ABHR42)
             IF         (%SWITCH(X1XXXXXX)) GOTO STEP99
             DLTOVR     FILE(INPUT)
             DLTOVR     FILE(OUTPUT)
             /* 選択フィールドのみでＰＦの作成 */
             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(WORKLIB/&FILE1) +
                          SRCFILE(FILELIB/ABHPP43) SRCMBR(ABHPP43) +
                          TEXT('パソコン取込みデータ') +
                          OPTION(*NOSOURCE *NOLIST) SIZE(20000 +
                          2000) LVLCHK(*NO)
             /* 選択フィールドのみの複写 */
             CPYF       FROMFILE(ABHPP41) TOFILE(WORKLIB/&FILE1) +
                          MBROPT(*ADD) CRTFILE(*NO) FMTOPT(*DROP *MAP)

 STEP02:     SNDPGMMSG  +
                          MSG('ＰＣのＥｘｃｅｌ用、工程内かんばんと+
                          部品情報データ' *CAT &US *CAT +
                          'がＷＯＲＫＬＩＢに作成されました。ＰＣ+
                          へ自動転送しますか？、自分で転送操作をし+
                          ますか？。自動の選択＜ＰＣに転送要求の設+
                          定（ＰＣ転送．ＴＴＯ）が登録されている+
                          場合のみ可能＞はＡ、手動の選択はＨで応答+
                          しなさい') TOMSGQ(&WSID) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         (&KOTAE = 'H') GOTO STEP03
             IF         (&KOTAE = 'A') GOTO STEP06
             GOTO       STEP02
 STEP03:     DSPDBM     FILE(WORKLIB/&FILE1)
             MONMSG     MSGID(CPA0701 EVX1201)
 STEP99:     DLTDTAARA  DTAARA(FILELIB/ABHACT41)
             MONMSG     MSGID(CPF2105 CPF9999)
             GOTO       END
 STEP06:     STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD('"C:$PROGRAM FILES$PERSONAL +
                          COMMUNICATIONS$PCSFT5.EXE" +
                          C:$AS400$TTO$ＰＣ転送.TTO') PAUSE(*NO)
             DLTDTAARA  DTAARA(FILELIB/ABHACT41)
             MONMSG     MSGID(CPF2105 CPF9999)
 END:        ENDPGM
