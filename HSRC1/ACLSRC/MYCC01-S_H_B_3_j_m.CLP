             PGM
             /** MYCC01 ************************/
             /* 設備負荷グラフ№３データ作成 */
             /* 『内示３ケ月』               */
             /*  I-HASADA          2017/12/13  */
             /************************ MYCC01 **/
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
             DCL        VAR(&PNJH1) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PNJH2) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PNJH3) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PJIYM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PTOYM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PKOJO) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PKOTI) TYPE(*CHAR) LEN(30)

             DCL        VAR(&PIPGMN) TYPE(*CHAR) LEN(10) +
                          VALUE('MYCC01    ')
             DCL        VAR(&POUSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POKONA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POSTTS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREC) TYPE(*DEC) LEN(3 0) VALUE(0)

             DCL        VAR(&MYCNP00) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYCWP02) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYCWP3A) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYCWP3B) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYCWP3X) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYCWP3Y) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYCWP04) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYCWP05) TYPE(*CHAR) LEN(10)

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

             CHGVAR     VAR(&MYCNP00) VALUE('MYCNP00' *CAT &WS)
             CHGVAR     VAR(&MYCWP02) VALUE('MYCWP02' *CAT &WS)
             CHGVAR     VAR(&MYCWP3A) VALUE('MYCWP3A' *CAT &WS)
             CHGVAR     VAR(&MYCWP3B) VALUE('MYCWP3B' *CAT &WS)
             CHGVAR     VAR(&MYCWP3X) VALUE('MYCWP3X' *CAT &WS)
             CHGVAR     VAR(&MYCWP3Y) VALUE('MYCWP3Y' *CAT &WS)
             CHGVAR     VAR(&MYCWP04) VALUE('MYCWP04' *CAT &WS)
             CHGVAR     VAR(&MYCWP05) VALUE('MYCWP05' *CAT &WS)

             RTVDTAARA  DTAARA(ABBDS3) RTNVAR(&ABBDS3)
             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)

             CHGVAR     VAR(&ABBDS) VALUE(%SST(&ABBDS3 1 6))
             CHGVAR     VAR(&MCEDP) VALUE(%SST(&MCEDP01 1 6))

    /*--------------*/
    /*  PGM:MYCR01  */
    /*--------------*/
             DLTF       FILE(&MYCNP00)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYCNP00) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(MYCNP00) +
                          TEXT('設備負荷グラフ№３') +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MYCNP00) TOFILE(&MYCNP00)
             CALL       PGM(MYCR01) PARM(&ABBDS &MCEDP &PNJH1 &PNJH2 +
                          &PNJH3 &PJIYM &PTOYM &PKOJO &PKOTI)
             DLTOVR     FILE(*ALL)

    /*--------*/
    /* 終了 */
    /*--------*/
             IF         (%SWITCH(X1XXXXXX)) DO
             DLTF       FILE(&MYCNP00)
             GOTO       END
             ENDDO

    /*--------------*/
    /* データ無し */
    /*--------------*/
             IF         (%SWITCH(0XXXXXXX)) DO
             CHGVAR     VAR(&PMSG) VALUE('THERE IS NO MADE DATA < +
                          REPLY=G >')
             CHGVAR     VAR(&PKINP) VALUE('G    ')
             CHGVAR     VAR(&PKOUT) VALUE(' ')

             CALL       PGM(AJGR11) PARM(&PMSG &PKINP &WSID &PKOUT)

             IF         (&PKOUT *EQ 'G') DO
             DLTF       FILE(&MYCNP00)
             GOTO       END
             ENDDO
             ENDDO

    /*--------------*/
    /*  PGM:MYCR02  */
    /*--------------*/
             DLTF       FILE(&MYCWP02)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYCWP02) RCDLEN(1800) +
                          TEXT('設備負荷グラフ№３(EXCE CSV)') +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MYCNP00) TOFILE(&MYCNP00)
             OVRDBF     FILE(MYCWP02) TOFILE(&MYCWP02)
             CALL       PGM(MYCR02) PARM(&PNJH1 &PNJH2 &PNJH3 &PJIYM +
                          &PTOYM)
             DLTF       FILE(&MYCNP00)
             DLTOVR     FILE(*ALL)

    /*--------------*/
    /*  PGM:MYCR03  */
    /*--------------*/
             DLTF       FILE(&MYCWP3A)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYCWP3A) RCDLEN(100) +
                          TEXT('設備負荷グラフ№３設備情報') +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&MYCWP3X)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYCWP3X) RCDLEN(100) +
                          TEXT('設備負荷グラフ№３機種') +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MYCWP3A) TOFILE(&MYCWP3A)
             OVRDBF     FILE(MYCWP3X) TOFILE(&MYCWP3X)
             CALL       PGM(MYCR03) PARM(&PJIYM &PKOJO &PKOTI)
             DLTOVR     FILE(*ALL)

    /*---------------*/
    /*  SORT:MYCS04  */
    /*---------------*/
             DLTF       FILE(&MYCWP3B)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYCWP3B) RCDLEN(100) +
                          TEXT('設備負荷グラフ№３設備情報') +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&MYCWP3A)) OUTFILE(&MYCWP3B) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(MYCS04) +
                          OPTION(*NOPRT)
             DLTF       FILE(&MYCWP3A)

    /*--------------*/
    /*  PGM:MYCR04  */
    /*--------------*/
             DLTF       FILE(&MYCWP04)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYCWP04) RCDLEN(200) +
                          TEXT('設備負荷グラフ№３設備情報(EXCEL +
                          CVS)') OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MYCWP3B) TOFILE(&MYCWP3B)
             OVRDBF     FILE(MYCWP04) TOFILE(&MYCWP04)
             CALL       PGM(MYCR04)
             DLTOVR     FILE(*ALL)
             DLTF       FILE(&MYCWP3B)

    /*---------------*/
    /*  SORT:MYCS05  */
    /*---------------*/
             DLTF       FILE(&MYCWP3Y)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYCWP3Y) RCDLEN(100) +
                          TEXT('設備負荷グラフ№３機種') +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&MYCWP3X)) OUTFILE(&MYCWP3Y) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(MYCS05) +
                          OPTION(*NOPRT)
             DLTF       FILE(&MYCWP3X)

    /*--------------*/
    /*  PGM:MYCR05  */
    /*--------------*/
             DLTF       FILE(&MYCWP05)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYCWP05) RCDLEN(200) +
                          TEXT('設備負荷グラフ№３機種(EXCEL +
                          CSV)') OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MYCWP3Y) TOFILE(&MYCWP3Y)
             OVRDBF     FILE(MYCWP05) TOFILE(&MYCWP05)
             CALL       PGM(MYCR05)
             DLTOVR     FILE(*ALL)
             DLTF       FILE(&MYCWP3Y)

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

    /*----------------------*/
    /*  AS400 --> PC        */
    /* 設備負荷グラフ№３ */
    /*  FILE:MYCWP02        */
    /*----------------------*/
             DLTF       FILE(MYCWP02)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/MYCWP02) RCDLEN(1800) +
                          TEXT('設備負荷グラフ№３(EXCE CSV)') +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             CPYF       FROMFILE(&MYCWP02) TOFILE(MYCWP02) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             DLTF       FILE(&MYCWP02)

             RTVNETA    SYSNAME(&PSYS)
             CHGVAR     VAR(&PARM1) VALUE('HWFILE1   ')
             CHGVAR     VAR(&PARM2) VALUE('MYCWP02   ')
             CHGVAR     VAR(&PARM3) VALUE(&PSYS)
             CHGVAR     VAR(&PARM4) +
                          VALUE('C:$AS400$DATA$MYCWP02.CSV            -
                                           ')
             CHGVAR     VAR(&PARM5) VALUE('1')

             CALL       PGM(AJGC01) PARM(&PARM1 &PARM2 &PARM3 &PARM4 +
                          &PARM5)

    /*--------------------------*/
    /*  AS400 --> PC            */
    /* 設備負荷グラフ№３設備 */
    /*  FILE:MYCWP04            */
    /*--------------------------*/
             DLTF       FILE(MYCWP04)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/MYCWP04) RCDLEN(200) +
                          TEXT('設備負荷グラフ№３設備情報(EXCEL +
                          CVS)') OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             CPYF       FROMFILE(&MYCWP04) TOFILE(MYCWP04) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             DLTF       FILE(&MYCWP04)

             RTVNETA    SYSNAME(&PSYS)
             CHGVAR     VAR(&PARM1) VALUE('HWFILE1   ')
             CHGVAR     VAR(&PARM2) VALUE('MYCWP04   ')
             CHGVAR     VAR(&PARM3) VALUE(&PSYS)
             CHGVAR     VAR(&PARM4) +
                          VALUE('C:$AS400$DATA$MYCWP04.CSV            -
                                           ')
             CHGVAR     VAR(&PARM5) VALUE('1')

             CALL       PGM(AJGC01) PARM(&PARM1 &PARM2 &PARM3 &PARM4 +
                          &PARM5)

    /*--------------------------*/
    /*  AS400 --> PC            */
    /* 設備負荷グラフ№３機種 */
    /*  FILE:MYCWP05            */
    /*--------------------------*/
             DLTF       FILE(MYCWP05)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/MYCWP05) RCDLEN(200) +
                          TEXT('設備負荷グラフ№３機種(EXCEL +
                          CSV)') OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             CPYF       FROMFILE(&MYCWP05) TOFILE(MYCWP05) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             DLTF       FILE(&MYCWP05)

             RTVNETA    SYSNAME(&PSYS)
             CHGVAR     VAR(&PARM1) VALUE('HWFILE1   ')
             CHGVAR     VAR(&PARM2) VALUE('MYCWP05   ')
             CHGVAR     VAR(&PARM3) VALUE(&PSYS)
             CHGVAR     VAR(&PARM4) +
                          VALUE('C:$AS400$DATA$MYCWP05.CSV            -
                                           ')
             CHGVAR     VAR(&PARM5) VALUE('1')

             CALL       PGM(AJGC01) PARM(&PARM1 &PARM2 &PARM3 &PARM4 +
                          &PARM5)

    /*--------------------*/
    /* 重複処理制御解除 */
    /*--------------------*/
             CALL       PGM(AJGR02) PARM(&PIPGMN)

 END:        ENDPGM
