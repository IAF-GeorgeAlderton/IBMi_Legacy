             PGM
             /** MYBC11 *********************************/
             /* 仕掛けﾜｮn及び出現率照会& mﾞｰj作成 */
             /*  ﾃﾇnﾈ]jｰ機番別                        */
             /*     I-HASADA             2013/02/28     */
             /*  I-HASADA 2013/04/04                    */
             /*   COPY RPG(IAFAYM):TG031C               */
             /********************************* MYBC11 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WS04) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PMSG) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)

             DCL        VAR(&PFCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PKOJO) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PKOTI) TYPE(*CHAR) LEN(30)
             DCL        VAR(&PCOST) TYPE(*CHAR) LEN(60)
             DCL        VAR(&PKUBN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PNATK) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PNAKI) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PBRYM) TYPE(*CHAR) LEN(6)

             DCL        VAR(&PIPGMN) TYPE(*CHAR) LEN(10) +
                          VALUE('MYBC11    ')
             DCL        VAR(&POUSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POKONA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POSTTS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREC) TYPE(*DEC) LEN(3 0) VALUE(0)

             DCL        VAR(&MYBNP1A) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYBNP1B) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYBWP11) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MYBWP13) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&WS04) VALUE(%SST(&WSID 1 4))

             CHGVAR     VAR(&MYBNP1A) VALUE('MYBNP1A' *CAT &WS)
             CHGVAR     VAR(&MYBNP1B) VALUE('MYBNP1B' *CAT &WS)
             CHGVAR     VAR(&MYBWP11) VALUE('MYBWP11' *CAT &WS)
             CHGVAR     VAR(&MYBWP13) VALUE('MYBWP13' *CAT &WS)

    /*--------------*/
    /*  PGM:MYBR11  */
    /*--------------*/
             DLTF       FILE(&MYBNP1A)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYBNP1A) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(MYBNP1A) +
                          TEXT('仕掛けﾜｮn及び出現率WORKmﾞｰj') +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&MYBNP1B)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYBNP1B) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(MYBNP1B) +
                          TEXT('仕掛けﾜｮn及び出現率WORKmﾞｰj') +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&MYBWP11)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYBWP11) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(MYBWP11) +
                          TEXT('仕掛けﾜｮn及び出現率ﾌﾟjｰ]表WORKm+
                          ﾞｰj') OPTION(*NOLIST *NOSRC) LVLCHK(*NO) +
                          AUT(*ALL)

 STP1:       CLRPFM     FILE(&MYBNP1A)
             CLRPFM     FILE(&MYBNP1B)

             OVRDBF     FILE(MYBNP1A) TOFILE(&MYBNP1A)
             OVRDBF     FILE(MYBWP11) TOFILE(&MYBWP11)
             CALL       PGM(MYBR11) PARM(&PFCMD &MYBWP11 &PKOJO +
                          &PKOTI &PCOST &PKUBN &PNATK &PNAKI &PBRYM)
             DLTOVR     FILE(*ALL)

    /*--------*/
    /* 終了 */
    /*--------*/
             IF         (&PFCMD *EQ 'F1') DO
             DLTF       FILE(&MYBNP1A)
             DLTF       FILE(&MYBNP1B)
             DLTF       FILE(&MYBWP11)
             GOTO       END
             ENDDO

    /*-------------------------*/
    /*  CPYF:MYBNP1A->MYBNP1B  */
    /*-------------------------*/
             CPYF       FROMFILE(&MYBNP1A) TOFILE(&MYBNP1B) +
                          MBROPT(*REPLACE) FMTOPT(*DROP *MAP)

    /*****************/
    /* 出力:照会 */
    /*****************/
    /*--------------*/
    /*  PGM:MYBR12  */
    /*--------------*/
             OVRDBF     FILE(MYBNP1B) TOFILE(&MYBNP1B)
             CALL       PGM(MYBR12) PARM(&PFCMD &PKOJO &PKOTI &PCOST)
             DLTOVR     FILE(*ALL)

             IF         (&PFCMD *EQ 'F3') DO
             GOTO       STP1
             ENDDO

    /***************************/
    /* 出力: EXCELmﾞｰj作成 */
    /***************************/
    /*--------------*/
    /*  PGM:MYBR13  */
    /*--------------*/
             DLTF       FILE(&MYBWP13)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYBWP13) RCDLEN(300) +
                          TEXT('仕掛けﾜｮn及び出現率mﾞｰj') +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MYBNP1B) TOFILE(&MYBNP1B)
             OVRDBF     FILE(MYBWP11) TOFILE(&MYBWP11)
             OVRDBF     FILE(MYBWP13) TOFILE(&MYBWP13)
             CALL       PGM(MYBR13) PARM(&PBRYM)
             DLTF       FILE(&MYBNP1A)
             DLTF       FILE(&MYBNP1B)
             DLTF       FILE(&MYBWP11)
             DLTOVR     FILE(*ALL)

    /*----------------------*/
    /* 重複処理制御START  */
    /*----------------------*/
 STPZ:       CALL       PGM(AJGR01) PARM(&PIPGMN &POUSID &POKONA +
                          &POSTTS)

             IF         (&POSTTS *NE '1') DO
             CHGVAR     VAR(&PREC) VALUE(&PREC + 1)

             IF         (&PREC *GE 12) DO
             CHGVAR     VAR(&PMSG) +
                          VALUE('他の端末で処理中です。(作業者:' +
                          *CAT &POUSID *CAT &POKONA *CAT ') +
                          重複処理制御解除が必要なので、ＩＴＧに電+
                          話して下さい。( ﾎﾟﾜhﾞ[wNO:TF001C ) +
                          【応答＝Ｇ】')
             CHGVAR     VAR(&PKINP) VALUE('G    ')
             CHGVAR     VAR(&PKOUT) VALUE(' ')

             CALL       PGM(AJGR11) PARM(&PMSG &PKINP &WSID &PKOUT)
             ENDDO

             DLYJOB     DLY(10)
             GOTO       STPZ
             ENDDO

    /*------------------------------*/
    /*  AS400 --> PC                */
    /* 仕掛けﾜｮn及び出現率mﾞｰj  */
    /*  FILE:MYBWP13                */
    /*------------------------------*/
             DLTF       FILE(MYBWP13)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/MYBWP13) RCDLEN(300) +
                          TEXT('仕掛けﾜｮn及び出現率mﾞｰj') +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             CPYF       FROMFILE(&MYBWP13) TOFILE(MYBWP13) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             DLTF       FILE(&MYBWP13)

             /*P-COM用-------------------------------------------*/
          /* IF         COND(&WS04 *NE 'MEIS') THEN(DO)                 */
          /* STRPCO     PCTA(*NO)                                       */
          /* MONMSG     MSGID(CPF0000)                                  */
          /* STRPCCMD   PCCMD('"C:/PROGRAM FILES/PERSONAL +             */
          /*              COMMUNICATIONS/PCSFT5.EXE" +                  */
          /*              C:/AS400/TTO/MYBWP13.TTO') PAUSE(*NO)         */
          /* ENDDO                                                      */
             /*------------------------------------------------------*/

             /*クライアントアクセス用------------------------------*/
          /* IF         COND(&WS04 *EQ 'MEIS') THEN(DO)                 */
             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD('"C:/PROGRAM FILES/IBM/CLIENT +
                          ACCESS/RTOPCB.EXE" +
                          C:/AS400/TTO/MYBWP13.DTF') PAUSE(*NO)
          /* ENDDO                                                      */
             /*------------------------------------------------------*/

    /*--------------------*/
    /* 重複処理制御解除 */
    /*--------------------*/
             CALL       PGM(AJGR02) PARM(&PIPGMN)

 END:        ENDPGM
