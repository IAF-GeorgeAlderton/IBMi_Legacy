             PGM
             /** MYCC95 ****************************/
             /* 引取かんばんマスター全データ作成 */
             /*    I-HASADA          2019/10/08    */
             /**************************** MYCC95 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(3)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PMSG) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30) +
                          VALUE('SECOND TREATMENT KANBAN MASTER')

             DCL        VAR(&PIPGMN) TYPE(*CHAR) LEN(10) +
                          VALUE('MYCC95    ')
             DCL        VAR(&POUSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POKONA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POSTTS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREC) TYPE(*DEC) LEN(3 0) VALUE(0)

             DCL        VAR(&MYCWP95) TYPE(*CHAR) LEN(10)

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

             CHGVAR     VAR(&MYCWP95) VALUE('MYCWP95' *CAT &WS)

    /*--------------*/
    /*  PGM:MYCR95  */
    /*--------------*/
             DLTF       FILE(&MYCWP95)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYCWP95) RCDLEN(1000) +
                          TEXT('引取かんばんマスター(EXCE CSV)') +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             OVRDBF     FILE(MYCWP95) TOFILE(&MYCWP95)
             CALL       PGM(MYCR95)
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

    /*------------------------*/
    /*  AS400 --> PC          */
    /* 引取かんばんマスター */
    /*  FILE:MYCWP95          */
    /*------------------------*/
             DLTF       FILE(MYCWP95)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/MYCWP95) RCDLEN(1000) +
                          TEXT('引取かんばんマスター(EXCE CSV)') +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             CPYF       FROMFILE(&MYCWP95) TOFILE(MYCWP95) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             DLTF       FILE(&MYCWP95)

             RTVNETA    SYSNAME(&PSYS)
             CHGVAR     VAR(&PARM1) VALUE('HWFILE1   ')
             CHGVAR     VAR(&PARM2) VALUE('MYCWP95   ')
             CHGVAR     VAR(&PARM3) VALUE(&PSYS)
             CHGVAR     VAR(&PARM4) +
                          VALUE('C:$AS400$DATA$MYCWP95.CSV            -
                                           ')
             CHGVAR     VAR(&PARM5) VALUE('1')

             CALL       PGM(AJGC01) PARM(&PARM1 &PARM2 &PARM3 &PARM4 +
                          &PARM5)

             CALL       PGM(APLC94) PARM('1' &PARM2 &PARM1 +
                          &FNAM 'Y' ' ' 'Y')


    /*--------------------*/
    /* 重複処理制御解除 */
    /*--------------------*/
             CALL       PGM(AJGR02) PARM(&PIPGMN)

 END:        ENDPGM
