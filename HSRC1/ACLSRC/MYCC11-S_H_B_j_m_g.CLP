             PGM
             /** MYCC11 **************************/
             /* 設備負荷グラフデータ作成『新』 */
             /* 『新バージョン』               */
             /*  I-HASADA            2017/12/15  */
             /************************** MYCC11 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(3)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PMSG) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)

             DCL        VAR(&ABBDS3) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ABBDS) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MCEDP01) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MCEDP) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PHYM1) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PHYM2) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PHYM3) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PHYM4) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PHCD1) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PHCD2) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PHCD3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PHCD4) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PKOJO) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PKOTI) TYPE(*CHAR) LEN(30)
             DCL        VAR(&PKTRT) TYPE(*CHAR) LEN(1)

             DCL        VAR(&PIPGMN) TYPE(*CHAR) LEN(10) +
                          VALUE('MYCC11    ')
             DCL        VAR(&POUSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POKONA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POSTTS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREC) TYPE(*DEC) LEN(3 0) VALUE(0)

             DCL        VAR(&MYCNP10) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYCNP12) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYCWP12) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYCWP13A) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYCWP13B) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYCWP13X) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYCWP13Y) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYCWP14) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYCWP15) TYPE(*CHAR) LEN(10)

    /*----------------------------------*/
    /* クライアントアクセス用変数定義 */
    /*----------------------------------*/
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(80)
             DCL        VAR(&PARM5) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PSYS) TYPE(*CHAR) LEN(10)

             CHGJOB     SWS(00000000)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&MYCNP10) VALUE('MYCNP10' *CAT &WS)
             CHGVAR     VAR(&MYCNP12) VALUE('MYCNP12' *CAT &WS)
             CHGVAR     VAR(&MYCWP12) VALUE('MYCWP12' *CAT &WS)
             CHGVAR     VAR(&MYCWP13A) VALUE('MYCWP13A' *CAT &WS)
             CHGVAR     VAR(&MYCWP13B) VALUE('MYCWP13B' *CAT &WS)
             CHGVAR     VAR(&MYCWP13X) VALUE('MYCWP13X' *CAT &WS)
             CHGVAR     VAR(&MYCWP13Y) VALUE('MYCWP13Y' *CAT &WS)
             CHGVAR     VAR(&MYCWP14) VALUE('MYCWP14' *CAT &WS)
             CHGVAR     VAR(&MYCWP15) VALUE('MYCWP15' *CAT &WS)

             RTVDTAARA  DTAARA(ABBDS3) RTNVAR(&ABBDS3)
             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)

             CHGVAR     VAR(&ABBDS) VALUE(%SST(&ABBDS3 1 6))
             CHGVAR     VAR(&MCEDP) VALUE(%SST(&MCEDP01 1 6))

    /*--------------*/
    /*  PGM:MYCR11  */
    /*--------------*/
             DLTF       FILE(&MYCNP10)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYCNP10) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(MYCNP10) +
                          TEXT('設備負荷グラフ『新』') +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&MYCNP12)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYCNP12) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(MYCNP12) +
                          TEXT('作業日報月別設備総合効率データ（回+
                          転数率計算）') OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MYCNP10) TOFILE(&MYCNP10)
             OVRDBF     FILE(MYCNP12) TOFILE(&MYCNP12)
             CALL       PGM(MYCR11) PARM(&ABBDS &MCEDP &PHYM1 &PHYM2 +
                          &PHYM3 &PHYM4 &PHCD1 &PHCD2 &PHCD3 &PHCD4 +
                          &PKOJO &PKOTI &PKTRT)
             DLTOVR     FILE(*ALL)

    /*--------*/
    /* 終了 */
    /*--------*/
             IF         (%SWITCH(X1XXXXXX)) DO
             DLTF       FILE(&MYCNP10)
             DLTF       FILE(&MYCNP12)
             GOTO       END
             ENDDO

    /*--------------*/
    /*  PGM:MYCR16  */
    /*--------------*/
             OVRDBF     FILE(MYCNP10) TOFILE(&MYCNP10)
             OVRDBF     FILE(MYCNP12) TOFILE(&MYCNP12)
             CALL       PGM(MYCR16)
             DLTOVR     FILE(*ALL)

    /*--------------*/
    /*  PGM:MYCR12  */
    /*--------------*/
             DLTF       FILE(&MYCWP12)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYCWP12) RCDLEN(1900) +
                          TEXT('設備負荷グラフ『新』<EXCEL>') +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MYCNP10) TOFILE(&MYCNP10)
             OVRDBF     FILE(MYCWP12) TOFILE(&MYCWP12)
             CALL       PGM(MYCR12) PARM(&PHYM1 &PHYM2 &PHYM3 &PHYM4 +
                          &PHCD1 &PHCD2 &PHCD3 &PHCD4 &PKOJO)
             DLTF       FILE(&MYCNP10)
             DLTOVR     FILE(*ALL)

    /*--------------*/
    /*  PGM:MYCR13  */
    /*--------------*/
             DLTF       FILE(&MYCWP13A)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYCWP13A) RCDLEN(100) +
                          TEXT('設備負荷グラフ設備情報『新』') +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&MYCWP13X)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYCWP13X) RCDLEN(100) +
                          TEXT('設備負荷グラフ機種情報『新』') +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MYCWP13A) TOFILE(&MYCWP13A)
             OVRDBF     FILE(MYCWP13X) TOFILE(&MYCWP13X)
             OVRDBF     FILE(MYCNP12) TOFILE(&MYCNP12)
             CALL       PGM(MYCR13) PARM(&PHYM1 &PKOJO &PKOTI &PKTRT)
             DLTOVR     FILE(*ALL)
             DLTF       FILE(&MYCNP12)

    /*---------------*/
    /*  SORT:MYCS14  */
    /*---------------*/
             DLTF       FILE(&MYCWP13B)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYCWP13B) RCDLEN(100) +
                          TEXT('設備負荷グラフ設備情報『新』') +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&MYCWP13A)) OUTFILE(&MYCWP13B) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(MYCS14) +
                          OPTION(*NOPRT)
             DLTF       FILE(&MYCWP13A)

    /*--------------*/
    /*  PGM:MYCR14  */
    /*--------------*/
             DLTF       FILE(&MYCWP14)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYCWP14) RCDLEN(200) +
                          TEXT('設備負荷グラフ設備情報『新』<EXCEL>+
                          ') OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MYCWP13B) TOFILE(&MYCWP13B)
             OVRDBF     FILE(MYCWP14) TOFILE(&MYCWP14)
             CALL       PGM(MYCR14) PARM(&PKTRT)
             DLTOVR     FILE(*ALL)
             DLTF       FILE(&MYCWP13B)

    /*---------------*/
    /*  SORT:MYCS15  */
    /*---------------*/
             DLTF       FILE(&MYCWP13Y)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYCWP13Y) RCDLEN(100) +
                          TEXT('設備負荷グラフ機種情報『新』') +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&MYCWP13X)) OUTFILE(&MYCWP13Y) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(MYCS15) +
                          OPTION(*NOPRT)
             DLTF       FILE(&MYCWP13X)

    /*--------------*/
    /*  PGM:MYCR15  */
    /*--------------*/
             DLTF       FILE(&MYCWP15)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYCWP15) RCDLEN(200) +
                          TEXT('設備負荷グラフ機種情報『新』<EXCEL>+
                          ') OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MYCWP13Y) TOFILE(&MYCWP13Y)
             OVRDBF     FILE(MYCWP15) TOFILE(&MYCWP15)
             CALL       PGM(MYCR15) PARM(&PKTRT)
             DLTOVR     FILE(*ALL)
             DLTF       FILE(&MYCWP13Y)

    /*----------------------*/
    /* 重複処理制御START  */
    /*----------------------*/
 STPZ:       CALL       PGM(AJGR01) PARM(&PIPGMN &POUSID &POKONA +
                          &POSTTS)

             IF         (&POSTTS *NE '1') DO
             CHGVAR     VAR(&PREC) VALUE(&PREC + 1)

    /*--------------------*/
    /* 重複処理制御解除 */
    /*--------------------*/
             IF         (&PREC *GE 12) DO
             CHGVAR     VAR(&PREC) VALUE(0)
             CALL       PGM(AJGR02) PARM(&PIPGMN)
             ENDDO

             DLYJOB     DLY(10)
             GOTO       STPZ
             ENDDO

    /*==================================*/
    /*  h[ba]nahﾈﾇ                      */
    /*  &PARM1 = [bﾎﾞ[ﾒｰ LEN(10)        */
    /*  &PARM2 = ﾎｦbﾓ名LEN(10)        */
    /*  &PARM3 = tﾇn     LEN(8)         */
    /*  &PARM4 = PCﾎｦbﾓ保管先LEN(80)  */
    /*  &PARM5 = PCﾎｦbﾓjbﾎﾟ    LEN(2)   */
    /*==================================*/

    /*--------------------*/
    /*  AS400 --> PC      */
    /* 設備負荷グラフ新 */
    /*  FILE:MYCWP12      */
    /*--------------------*/
             DLTF       FILE(MYCWP12)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/MYCWP12) RCDLEN(1900) +
                          TEXT('設備負荷グラフ『新』<EXCEL>') +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             CPYF       FROMFILE(&MYCWP12) TOFILE(MYCWP12) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             DLTF       FILE(&MYCWP12)

             RTVNETA    SYSNAME(&PSYS)
             CHGVAR     VAR(&PARM1) VALUE('HWFILE1   ')
             CHGVAR     VAR(&PARM2) VALUE('MYCWP12   ')
             CHGVAR     VAR(&PARM3) VALUE(&PSYS)
             CHGVAR     VAR(&PARM4) +
                          VALUE('C:$AS400$DATA$MYCWP12.CSV            -
                                           ')
             CHGVAR     VAR(&PARM5) VALUE('1')

             CALL       PGM(AJGC01) PARM(&PARM1 &PARM2 &PARM3 &PARM4 +
                          &PARM5)

    /*------------------------*/
    /*  AS400 --> PC          */
    /* 設備負荷グラフ新設備 */
    /*  FILE:MYCWP14          */
    /*------------------------*/
             DLTF       FILE(MYCWP14)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/MYCWP14) RCDLEN(200) +
                          TEXT('設備負荷グラフ設備情報『新』<EXCEL>+
                          ') OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             CPYF       FROMFILE(&MYCWP14) TOFILE(MYCWP14) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             DLTF       FILE(&MYCWP14)

             RTVNETA    SYSNAME(&PSYS)
             CHGVAR     VAR(&PARM1) VALUE('HWFILE1   ')
             CHGVAR     VAR(&PARM2) VALUE('MYCWP14   ')
             CHGVAR     VAR(&PARM3) VALUE(&PSYS)
             CHGVAR     VAR(&PARM4) +
                          VALUE('C:$AS400$DATA$MYCWP14.CSV            -
                                           ')
             CHGVAR     VAR(&PARM5) VALUE('1')

             CALL       PGM(AJGC01) PARM(&PARM1 &PARM2 &PARM3 &PARM4 +
                          &PARM5)

    /*------------------------*/
    /*  AS400 --> PC          */
    /* 設備負荷グラフ新機種 */
    /*  FILE:MYCWP15          */
    /*------------------------*/
             DLTF       FILE(MYCWP15)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/MYCWP15) RCDLEN(200) +
                          TEXT('設備負荷グラフ機種情報『新』<EXCEL>+
                          ') OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             CPYF       FROMFILE(&MYCWP15) TOFILE(MYCWP15) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             DLTF       FILE(&MYCWP15)

             RTVNETA    SYSNAME(&PSYS)
             CHGVAR     VAR(&PARM1) VALUE('HWFILE1   ')
             CHGVAR     VAR(&PARM2) VALUE('MYCWP15   ')
             CHGVAR     VAR(&PARM3) VALUE(&PSYS)
             CHGVAR     VAR(&PARM4) +
                          VALUE('C:$AS400$DATA$MYCWP15.CSV            -
                                           ')
             CHGVAR     VAR(&PARM5) VALUE('1')

             CALL       PGM(AJGC01) PARM(&PARM1 &PARM2 &PARM3 &PARM4 +
                          &PARM5)

    /*--------------------*/
    /* 重複処理制御解除 */
    /*--------------------*/
             CALL       PGM(AJGR02) PARM(&PIPGMN)

 END:        ENDPGM
