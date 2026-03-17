             PGM
             /*** AO#C03 ***********************************/
             /* ISSUE TOYOTA LABELS                        */
             /*  ITS.              2016.03.21              */
             /**********************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&AO#WP10) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AO#WP11) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AO#WP12) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AO#WP13) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AL#WP13) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P1KIHZ) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             CHGVAR     VAR(&AO#WP10) VALUE('AO#WP10' *CAT &WS3)
             CHGVAR     VAR(&AO#WP11) VALUE('AO#WP11' *CAT &WS3)
             CHGVAR     VAR(&AO#WP12) VALUE('AO#WP12' *CAT &WS3)
             CHGVAR     VAR(&AO#WP13) VALUE('AO#WP13' *CAT &WS3)
             CHGVAR     VAR(&AL#WP13) VALUE('AL#WP13' *CAT &WS3)

             CHGJOB     OUTQ(&PRTG)

 #STP05:
        /* AL#PP11に品番点数をセット*/
             CALL       PGM(AL#R07)

        /* 2016.02.18番地条件でのパレットＰＵＬＬＩＮＧ  */
             CALL       PGM(AL#R15)
 #STP10:
        /* AL#PP11を集計する*/
        /* AL#PP11はＳＨＩＰＤＡＴＥ、客先トラック便、　　　*/
        /*          納、工、受、オーダー＃、客先パレット＃  */
        /*        　ごとの箱数合計ファイル　　              */
        /* AO#WP10トラック便、納入先ごとのパレット種類*/
        /* AO#WP11  AL#PP11をそのまま出力*/
             DLTF       FILE(&WLIB/&AO#WP10)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AO#WP10) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AO#WP10) +
                          OPTION(*NOLIST *NOSRC) SIZE(9999 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             DLTF       FILE(&WLIB/&AO#WP11)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AO#WP11) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AO#WP11) +
                          OPTION(*NOLIST *NOSRC) SIZE(9999 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AO#WP10) TOFILE(&WLIB/&AO#WP10)
             OVRDBF     FILE(AO#WP11) TOFILE(&WLIB/&AO#WP11)
             CALL       PGM(AO#R03)
 #STP17:
        /*便でパレットが１種類をパレットＰＵＬＬＩＮＧに  */
        /* 2016.02.18パレットプーリング条件変更のためやめる */
        /**  CALL       PGM(AL#R10)   ******/
 #STP20:
        /*ＩＡＦ便をセットする*/
             DLTF       FILE(&WLIB/&AO#WP12)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AO#WP12) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AO#WP12) +
                          OPTION(*NOLIST *NOSRC) SIZE(9999 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AO#WP10) TOFILE(&WLIB/&AO#WP10)
             OVRDBF     FILE(AO#WP12) TOFILE(&WLIB/&AO#WP12)
             CALL       PGM(AO#R04)
 #STP30:
        /* AO#WP11とAO#WP12からAO#WP13を作成*/
             DLTF       FILE(&WLIB/&AO#WP13)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AO#WP13) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AO#WP13) +
                          OPTION(*NOLIST *NOSRC) SIZE(9999 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             DLTF       FILE(&WLIB/&AL#WP13)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AL#WP13) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AL#WP13) +
                          OPTION(*NOLIST *NOSRC) SIZE(9999 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AO#WP11) TOFILE(&WLIB/&AO#WP11)
             OVRDBF     FILE(AO#WP12) TOFILE(&WLIB/&AO#WP12)
             OVRDBF     FILE(AO#WP13) TOFILE(&WLIB/&AO#WP13)
             OVRDBF     FILE(AL#WP13) TOFILE(&WLIB/&AL#WP13)
             CALL       PGM(AO#R05)
             CALL       PGM(AO#R06)
        /* AO#WP13 ---> AL#WP13 */
             CALL       PGM(AO#R07)
        /* AL#WP13にＩＡＦパレット＃をセットする*/
             CALL       PGM(AL#R06)
 #STP40:
             CALL       PGM(AO#RT5) PARM(&PCMD)
             IF         COND(&PCMD *EQ '01') THEN(DO)
             GOTO       CMDLBL(END)
             ENDDO
 #STP50:
         /*ＩＡＦ情報をAL#PP01へセット*/
             OVRDBF     FILE(AL#WP13) TOFILE(&WLIB/&AL#WP13)
             CALL       PGM(AL#R08)
 END:
             ENDPGM
