             PGM
             /** MYCC21 **************************/
             /* 熱処理設備負荷グラフデータ作成 */
             /* 『新バージョン』               */
             /*    I-HASADA        2017/12/20    */
             /************************** MYCC21 **/
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

             DCL        VAR(&PIPGMN) TYPE(*CHAR) LEN(10) +
                          VALUE('MYCC21    ')
             DCL        VAR(&POUSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POKONA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POSTTS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREC) TYPE(*DEC) LEN(3 0) VALUE(0)

             DCL        VAR(&MYCNP21) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYCWP22) TYPE(*CHAR) LEN(10)

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

             CHGVAR     VAR(&MYCNP21) VALUE('MYCNP21' *CAT &WS)
             CHGVAR     VAR(&MYCWP22) VALUE('MYCWP22' *CAT &WS)

             RTVDTAARA  DTAARA(ABBDS3) RTNVAR(&ABBDS3)
             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)

             CHGVAR     VAR(&ABBDS) VALUE(%SST(&ABBDS3 1 6))
             CHGVAR     VAR(&MCEDP) VALUE(%SST(&MCEDP01 1 6))

    /*--------------*/
    /*  PGM:MYCR21  */
    /*--------------*/
             DLTF       FILE(&MYCNP21)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYCNP21) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(MYCNP21) +
                          TEXT('熱処理設備負荷グラフデータ『新』') +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MYCNP21) TOFILE(&MYCNP21)
             CALL       PGM(MYCR21) PARM(&ABBDS &MCEDP &PHYM1 &PHYM2 +
                          &PHYM3 &PHYM4 &PHCD1 &PHCD2 &PHCD3 &PHCD4)
             DLTOVR     FILE(*ALL)

    /*--------*/
    /* 終了 */
    /*--------*/
             IF         (%SWITCH(X1XXXXXX)) DO
             DLTF       FILE(&MYCNP21)
             GOTO       END
             ENDDO

    /*--------------*/
    /*  PGM:MYCR22  */
    /*--------------*/
             DLTF       FILE(&MYCWP22)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYCWP22) RCDLEN(1900) +
                          TEXT('熱処理設備負荷グラフ<EXCEL>') +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MYCNP21) TOFILE(&MYCNP21)
             OVRDBF     FILE(MYCWP22) TOFILE(&MYCWP22)
             CALL       PGM(MYCR22) PARM(&PHYM1 &PHYM2 &PHYM3 &PHYM4 +
                          &PHCD1 &PHCD2 &PHCD3 &PHCD4)
             DLTF       FILE(&MYCNP21)
             DLTOVR     FILE(*ALL)

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

    /*--------------------------*/
    /*  AS400 --> PC            */
    /* 熱処理設備負荷グラフ新 */
    /*  FILE:MYCWP22            */
    /*--------------------------*/
             DLTF       FILE(MYCWP22)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/MYCWP22) RCDLEN(1900) +
                          TEXT('設備負荷グラフ『新』<EXCEL>') +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             CPYF       FROMFILE(&MYCWP22) TOFILE(MYCWP22) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             DLTF       FILE(&MYCWP22)

             RTVNETA    SYSNAME(&PSYS)
             CHGVAR     VAR(&PARM1) VALUE('HWFILE1   ')
             CHGVAR     VAR(&PARM2) VALUE('MYCWP22   ')
             CHGVAR     VAR(&PARM3) VALUE(&PSYS)
             CHGVAR     VAR(&PARM4) +
                          VALUE('C:$AS400$DATA$MYCWP22.CSV            -
                                           ')
             CHGVAR     VAR(&PARM5) VALUE('1')

             CALL       PGM(AJGC01) PARM(&PARM1 &PARM2 &PARM3 &PARM4 +
                          &PARM5)

    /*--------------------*/
    /* 重複処理制御解除 */
    /*--------------------*/
             CALL       PGM(AJGR02) PARM(&PIPGMN)

 END:        ENDPGM
