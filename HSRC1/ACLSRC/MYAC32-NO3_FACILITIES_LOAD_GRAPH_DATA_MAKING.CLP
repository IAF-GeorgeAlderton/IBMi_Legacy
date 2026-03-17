             PGM
             /** MYAC32 **********************************/
             /*  NO3. FACILITIES LOAD GRAPH DATA MAKING  */
             /* 設備負荷グラフ№３データ作成           */
             /*      I-HASADA            2013/03/11      */
             /********************************** MYAC32 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WS04) TYPE(*CHAR) LEN(4)
/* TCHK1 */  DCL        VAR(&WS01) TYPE(*CHAR) LEN(1)
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
                          VALUE('MYAC31    ')
             DCL        VAR(&POUSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POKONA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POSTTS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREC) TYPE(*DEC) LEN(3 0) VALUE(0)

             DCL        VAR(&MYANP31) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYANP32) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYAWP32) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYAWP33) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYAWP3A) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYAWP3B) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYAWP34) TYPE(*CHAR) LEN(10)

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
             CHGVAR     VAR(&WS04) VALUE(%SST(&WSID 1 4))
/* TCHK1 */  CHGVAR     VAR(&WS01) VALUE(%SST(&WSID 1 1))

             CHGVAR     VAR(&MYANP31) VALUE('MYANP31' *CAT &WS)
             CHGVAR     VAR(&MYANP32) VALUE('MYANP32' *CAT &WS)
             CHGVAR     VAR(&MYAWP32) VALUE('MYAWP32' *CAT &WS)
             CHGVAR     VAR(&MYAWP33) VALUE('MYAWP33' *CAT &WS)
             CHGVAR     VAR(&MYAWP3A) VALUE('MYAWP3A' *CAT &WS)
             CHGVAR     VAR(&MYAWP3B) VALUE('MYAWP3B' *CAT &WS)
             CHGVAR     VAR(&MYAWP34) VALUE('MYAWP34' *CAT &WS)

             RTVDTAARA  DTAARA(ABBDS3) RTNVAR(&ABBDS3)
             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)

             CHGVAR     VAR(&ABBDS) VALUE(%SST(&ABBDS3 1 6))
             CHGVAR     VAR(&MCEDP) VALUE(%SST(&MCEDP01 1 6))

    /*--------------*/
    /*  PGM:MYAR31  */
    /*--------------*/
             DLTF       FILE(&MYANP31)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYANP31) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(MYANP31) +
                          TEXT('NO3. FACILITIES LOAD GRAPH DATA') +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&MYANP32)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYANP32) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(MYANP32) +
                          TEXT('NO3. FACILITIES LOAD GRAPH MODEL +
                          NUMBER DATA') OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MYANP31) TOFILE(&MYANP31)
             OVRDBF     FILE(MYANP32) TOFILE(&MYANP32)
             CALL       PGM(MYAR31) PARM(&ABBDS &MCEDP &PNJH1 &PNJH2 +
                          &PNJH3 &PJIYM &PTOYM &PKOJO &PKOTI)
             DLTOVR     FILE(*ALL)

    /*--------*/
    /* 終了 */
    /*--------*/
             IF         (%SWITCH(X1XXXXXX)) DO
             DLTF       FILE(&MYANP31)
             DLTF       FILE(&MYANP32)
             GOTO       END
             ENDDO

    /*--------------*/
    /* データ無し */
    /*--------------*/
             IF         (%SWITCH(0XXXXXXX)) DO

             CHGVAR     VAR(&PMSG) VALUE('THERE ARE NOT DATA MAKING +
                          NO3. FACILITIES LOAD GRAPH DATA < REPLY=G >')
             CHGVAR     VAR(&PKINP) VALUE('G    ')
             CHGVAR     VAR(&PKOUT) VALUE(' ')

             CALL       PGM(AJGR11) PARM(&PMSG &PKINP &WSID &PKOUT)

             IF         (&PKOUT *EQ 'G') DO
             DLTF       FILE(&MYANP31)
             DLTF       FILE(&MYANP32)
             GOTO       END
             ENDDO

             ENDDO

    /*--------------*/
    /*  PGM:MYAR32  */
    /*--------------*/
             DLTF       FILE(&MYAWP32)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYAWP32) RCDLEN(1800) +
                          TEXT('NO3. FACILITIES LOAD GRAPH DATA') +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MYANP31) TOFILE(&MYANP31)
             OVRDBF     FILE(MYAWP32) TOFILE(&MYAWP32)
             CALL       PGM(MYAR32) PARM(&PNJH1 &PNJH2 &PNJH3 &PJIYM +
                          &PTOYM)
             DLTF       FILE(&MYANP31)
             DLTOVR     FILE(*ALL)

    /*--------------*/
    /*  PGM:MYAR33  */
    /*--------------*/
             DLTF       FILE(&MYAWP33)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYAWP33) RCDLEN(200) +
                          TEXT('NO3. FACILITIES LOAD GRAPH DATA +
                          <INFORMATION>') OPTION(*NOLIST) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&MYAWP3A)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYAWP3A) RCDLEN(100) +
                          TEXT('NO3. FACILITIES LOAD GRAPH MODEL +
                          NUMBER DATA') OPTION(*NOLIST) LVLCHK(*NO) +
                          AUT(*ALL)

             OVRDBF     FILE(MYAWP33) TOFILE(&MYAWP33)
             OVRDBF     FILE(MYAWP3A) TOFILE(&MYAWP3A)
             CALL       PGM(MYAR33) PARM(&PJIYM &PKOJO &PKOTI)
             DLTOVR     FILE(*ALL)

    /*---------------*/
    /*  SORT:MYAS33  */
    /*---------------*/
             DLTF       FILE(&MYAWP3B)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYAWP3B) RCDLEN(100) +
                          TEXT('NO3. FACILITIES LOAD GRAPH MODEL +
                          NUMBER DATA') OPTION(*NOLIST) LVLCHK(*NO) +
                          AUT(*ALL)

             FMTDTA     INFILE((&MYAWP3A)) OUTFILE(&MYAWP3B) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(MYAS33) +
                          OPTION(*NOPRT)
             DLTF       FILE(&MYAWP3A)

    /*--------------*/
    /*  PGM:MYAR34  */
    /*--------------*/
             DLTF       FILE(&MYAWP34)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYAWP34) RCDLEN(200) +
                          TEXT('NO3. FACILITIES LOAD GRAPH MODEL +
                          NUMBER DATA') OPTION(*NOLIST) LVLCHK(*NO) +
                          AUT(*ALL)

             OVRDBF     FILE(MYAWP3B) TOFILE(&MYAWP3B)
             OVRDBF     FILE(MYANP32) TOFILE(&MYANP32)
             OVRDBF     FILE(MYAWP34) TOFILE(&MYAWP34)
             CALL       PGM(MYAR34)
             DLTOVR     FILE(*ALL)
             DLTF       FILE(&MYAWP3B)
             DLTF       FILE(&MYANP32)

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

    /*----------------------------*/
    /*  AS400 --> PC              */
    /* 設備負荷グラフ№３データ */
    /*  FILE:MYAWP32              */
    /*----------------------------*/
             DLTF       FILE(MYAWP32)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/MYAWP32) RCDLEN(1800) +
                          TEXT('NO3. FACILITIES LOAD GRAPH DATA') +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             CPYF       FROMFILE(&MYAWP32) TOFILE(MYAWP32) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             DLTF       FILE(&MYAWP32)

             RTVNETA    SYSNAME(&PSYS)
             CHGVAR     VAR(&PARM1) VALUE('HWFILE1   ')
             CHGVAR     VAR(&PARM2) VALUE('MYAWP32   ')
             CHGVAR     VAR(&PARM3) VALUE(&PSYS)
             CHGVAR     VAR(&PARM4) +
                          VALUE('C:$AS400$DATA$設備負荷№３.CSV     -
                                           ')
             CHGVAR     VAR(&PARM5) VALUE('1')

             CALL       PGM(AJGC01) PARM(&PARM1 &PARM2 &PARM3 &PARM4 +
                          &PARM5)

    /*------------------------------------*/
    /*  AS400 --> PC                      */
    /* 設備負荷グラフ№３設備情報データ */
    /*  FILE:MYAWP33                      */
    /*------------------------------------*/
             DLTF       FILE(MYAWP33)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/MYAWP33) RCDLEN(200) +
                          TEXT('NO3. FACILITIES LOAD GRAPH DATA +
                          <INFORMATION>') OPTION(*NOLIST) +
                          LVLCHK(*NO) AUT(*ALL)

             CPYF       FROMFILE(&MYAWP33) TOFILE(MYAWP33) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             DLTF       FILE(&MYAWP33)

             RTVNETA    SYSNAME(&PSYS)
             CHGVAR     VAR(&PARM1) VALUE('HWFILE1   ')
             CHGVAR     VAR(&PARM2) VALUE('MYAWP33   ')
             CHGVAR     VAR(&PARM3) VALUE(&PSYS)
             CHGVAR     VAR(&PARM4) +
                          VALUE('C:$AS400$DATA$設備負荷№３設備.CSV -
                                           ')
             CHGVAR     VAR(&PARM5) VALUE('1')

             CALL       PGM(AJGC01) PARM(&PARM1 &PARM2 &PARM3 &PARM4 +
                          &PARM5)

    /*--------------------------------*/
    /*  AS400 --> PC                  */
    /* 設備負荷グラフ№３機種データ */
    /*  FILE:MYAWP34                  */
    /*--------------------------------*/
             DLTF       FILE(MYAWP34)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/MYAWP34) RCDLEN(200) +
                          TEXT('NO3. FACILITIES LOAD GRAPH MODEL +
                          NUMBER DATA') OPTION(*NOLIST) LVLCHK(*NO) +
                          AUT(*ALL)

             CPYF       FROMFILE(&MYAWP34) TOFILE(MYAWP34) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             DLTF       FILE(&MYAWP34)

             RTVNETA    SYSNAME(&PSYS)
             CHGVAR     VAR(&PARM1) VALUE('HWFILE1   ')
             CHGVAR     VAR(&PARM2) VALUE('MYAWP34   ')
             CHGVAR     VAR(&PARM3) VALUE(&PSYS)
             CHGVAR     VAR(&PARM4) +
                          VALUE('C:$AS400$DATA$設備負荷№３機種.CSV -
                                           ')
             CHGVAR     VAR(&PARM5) VALUE('1')

             CALL       PGM(AJGC01) PARM(&PARM1 &PARM2 &PARM3 &PARM4 +
                          &PARM5)

    /*--------------------*/
    /* 重複処理制御解除 */
    /*--------------------*/
             CALL       PGM(AJGR02) PARM(&PIPGMN)

 END:        ENDPGM
