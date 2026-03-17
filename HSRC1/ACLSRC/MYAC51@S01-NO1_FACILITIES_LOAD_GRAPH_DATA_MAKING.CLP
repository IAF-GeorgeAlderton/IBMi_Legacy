             PGM
             /** MYAC51 **********************************/
             /*  NO1. FACILITIES LOAD GRAPH DATA MAKING  */
             /* 設備負荷グラフ№１データ作成           */
             /*      I-HASADA            2013/03/13      */
             /********************************** MYAC51 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WS04) TYPE(*CHAR) LEN(4)
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
             DCL        VAR(&PNJYM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PJIYM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PKOJO) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PKOTI) TYPE(*CHAR) LEN(30)

             DCL        VAR(&PIPGMN) TYPE(*CHAR) LEN(10) +
                          VALUE('MYAC51    ')
             DCL        VAR(&POUSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POKONA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POSTTS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREC) TYPE(*DEC) LEN(3 0) VALUE(0)

             DCL        VAR(&MYANP51) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYAWP52) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYAWP5A) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYAWP53) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYAWP54) TYPE(*CHAR) LEN(10)

             CHGJOB     SWS(00000000)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&WS04) VALUE(%SST(&WSID 1 4))

             CHGVAR     VAR(&MYANP51) VALUE('MYANP51' *CAT &WS)
             CHGVAR     VAR(&MYAWP52) VALUE('MYAWP52' *CAT &WS)
             CHGVAR     VAR(&MYAWP5A) VALUE('MYAWP5A' *CAT &WS)
             CHGVAR     VAR(&MYAWP53) VALUE('MYAWP53' *CAT &WS)
             CHGVAR     VAR(&MYAWP54) VALUE('MYAWP54' *CAT &WS)

             RTVDTAARA  DTAARA(ABBDS3) RTNVAR(&ABBDS3)
             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)

             CHGVAR     VAR(&ABBDS) VALUE(%SST(&ABBDS3 1 6))
             CHGVAR     VAR(&MCEDP) VALUE(%SST(&MCEDP01 1 6))

    /*--------------*/
    /*  PGM:MYAR51  */
    /*--------------*/
             DLTF       FILE(&MYANP51)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYANP51) +
                          SRCFILE(HSRC1/MDDSSRC) SRCMBR(MYANP51) +
                          TEXT('NO1. FACILITIES LOAD GRAPH DATA') +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MYANP51) TOFILE(&MYANP51)
             CALL       PGM(MYAR51) PARM(&ABBDS &MCEDP &PNJYM &PJIYM +
                          &PKOJO &PKOTI)
             DLTOVR     FILE(*ALL)

    /*--------*/
    /* 終了 */
    /*--------*/
             IF         (%SWITCH(X1XXXXXX)) DO
             DLTF       FILE(&MYANP51)
             GOTO       END
             ENDDO

    /*-------------*/
    /*  mﾞｰj無し */
    /*-------------*/
             IF         (%SWITCH(0XXXXXXX)) DO

             CHGVAR     VAR(&PMSG) VALUE('THERE ARE NOT DATA MAKING +
                          NO1. FACILITIES LOAD GRAPH DATA < REPLY=G >')
             CHGVAR     VAR(&PKINP) VALUE('G    ')
             CHGVAR     VAR(&PKOUT) VALUE(' ')

             CALL       PGM(AJGR11) PARM(&PMSG &PKINP &WSID &PKOUT)

             IF         (&PKOUT *EQ 'G') DO
             DLTF       FILE(&MYANP51)
             GOTO       END
             ENDDO

             ENDDO

    /*--------------*/
    /*  PGM:MYAR52  */
    /*--------------*/
             DLTF       FILE(&MYAWP52)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYAWP52) RCDLEN(300) +
                          TEXT('NO1. FACILITIES LOAD GRAPH DATA') +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MYANP51) TOFILE(&MYANP51)
             OVRDBF     FILE(MYAWP52) TOFILE(&MYAWP52)
             CALL       PGM(MYAR52)
             DLTF       FILE(&MYANP51)
             DLTOVR     FILE(*ALL)

    /*---------------*/
    /*  SORT:MYAS52  */
    /*---------------*/
             DLTF       FILE(&MYAWP5A)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYAWP5A) RCDLEN(300) +
                          TEXT('NO1. FACILITIES LOAD GRAPH DATA') +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&MYAWP52)) OUTFILE(&MYAWP5A) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(MYAS52) +
                          OPTION(*NOPRT)
             DLTF       FILE(&MYAWP52)

    /*--------------*/
    /*  PGM:MYAR53  */
    /*--------------*/
             DLTF       FILE(&MYAWP53)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYAWP53) RCDLEN(1100) +
                          TEXT('NO1. FACILITIES LOAD GRAPH DATA') +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MYAWP5A) TOFILE(&MYAWP5A)
             OVRDBF     FILE(MYAWP53) TOFILE(&MYAWP53)
             CALL       PGM(MYAR53) PARM(&PNJYM &PJIYM)
             DLTF       FILE(&MYAWP5A)
             DLTOVR     FILE(*ALL)

    /*--------------*/
    /*  PGM:MYAR54  */
    /*--------------*/
             DLTF       FILE(&MYAWP54)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYAWP54) RCDLEN(200) +
                          TEXT('NO1. FACILITIES LOAD GRAPH DATA +
                          <INFORMATION>') OPTION(*NOLIST) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MYAWP54) TOFILE(&MYAWP54)
             CALL       PGM(MYAR54) PARM(&PJIYM &PKOJO &PKOTI)
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

    /*----------------------------*/
    /*  AS400 --> PC              */
    /* 設備負荷グラフ№１データ */
    /*  FILE:MYAWP53              */
    /*----------------------------*/
             DLTF       FILE(MYAWP53)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/MYAWP53) RCDLEN(1100) +
                          TEXT('NO1. FACILITIES LOAD GRAPH DATA') +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             CPYF       FROMFILE(&MYAWP53) TOFILE(MYAWP53) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             DLTF       FILE(&MYAWP53)

             /*P-COM用-------------------------------------------*/
          /* IF         COND(&WS04 *NE 'MEIS') THEN(DO)                 */
          /* STRPCO     PCTA(*NO)                                       */
          /* MONMSG     MSGID(CPF0000)                                  */
          /* STRPCCMD   PCCMD('"C:/PROGRAM FILES/PERSONAL +             */
          /*              COMMUNICATIONS/PCSFT5.EXE" +                  */
          /*              C:/AS400/TTO/MYAWP53.TTO') PAUSE(*NO)         */
          /* ENDDO                                                      */
             /*------------------------------------------------------*/

             /*クライアントアクセス用------------------------------*/
          /* IF         COND(&WS04 *EQ 'MEIS') THEN(DO)                 */
             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD('"C:/PROGRAM FILES/IBM/CLIENT +
                          ACCESS/RTOPCB.EXE" +
                          C:/AS400/TTO/MYAWP53.DTF') PAUSE(*NO)
          /* ENDDO                                                      */
             /*------------------------------------------------------*/

    /*------------------------------------*/
    /*  AS400 --> PC                      */
    /* 設備負荷グラフ№１設備情報データ */
    /*  FILE:MYAWP54                      */
    /*------------------------------------*/
             DLTF       FILE(MYAWP54)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/MYAWP54) RCDLEN(200) +
                          TEXT('NO1. FACILITIES LOAD GRAPH DATA +
                          <INFORMATION>') OPTION(*NOLIST) +
                          LVLCHK(*NO) AUT(*ALL)

             CPYF       FROMFILE(&MYAWP54) TOFILE(MYAWP54) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             DLTF       FILE(&MYAWP54)

             CALL       PGM(TSKC90)

             /*P-COM用-------------------------------------------*/
          /* IF         COND(&WS04 *NE 'MEIS') THEN(DO)                 */
          /* STRPCO     PCTA(*NO)                                       */
          /* MONMSG     MSGID(CPF0000)                                  */
          /* STRPCCMD   PCCMD('"C:/PROGRAM FILES/PERSONAL +             */
          /*              COMMUNICATIONS/PCSFT5.EXE" +                  */
          /*              C:/AS400/TTO/MYAWP54.TTO') PAUSE(*NO)         */
          /* ENDDO                                                      */
             /*------------------------------------------------------*/

             /*クライアントアクセス用------------------------------*/
          /* IF         COND(&WS04 *EQ 'MEIS') THEN(DO)                 */
             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD('"C:/PROGRAM FILES/IBM/CLIENT +
                          ACCESS/RTOPCB.EXE" +
                          C:/AS400/TTO/MYAWP54.DTF') PAUSE(*NO)
          /* ENDDO                                                      */
             /*------------------------------------------------------*/

    /*--------------------*/
    /* 重複処理制御解除 */
    /*--------------------*/
             CALL       PGM(AJGR02) PARM(&PIPGMN)

 END:        ENDPGM
