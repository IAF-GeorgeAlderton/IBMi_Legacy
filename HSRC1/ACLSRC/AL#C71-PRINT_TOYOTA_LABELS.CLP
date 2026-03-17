             PGM        PARM(&OUTR)
             /*** AL#C71 ***********************************/
             /* ISSUE TOYOTA LABELS                        */
             /*  ITS.              2015.05.26              */
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
             DCL        VAR(&AL#WP46) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AL#WP71) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AL#WP73) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BL#WP73) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AL#WP7L) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AL#WP7C) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AL#WP77) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P1KIHZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&OUTR)     TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&P7FIXD) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&P7FIXT) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&P7TIMS) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&P7TRKB) TYPE(*CHAR) LEN(02)
             DCL        VAR(&P7IAFB) TYPE(*CHAR) LEN(03)
             DCL        VAR(&P9MAIS) TYPE(*DEC) LEN(03 0)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             CHGVAR     VAR(&AL#WP46) VALUE('AL#WP46' *CAT &WS3)
             CHGVAR     VAR(&AL#WP71) VALUE('AL#WP71' *CAT &WS3)
             CHGVAR     VAR(&AL#WP73) VALUE('AL#WP73' *CAT &WS3)
             CHGVAR     VAR(&BL#WP73) VALUE('BL#WP73' *CAT &WS3)
             CHGVAR     VAR(&AL#WP7C) VALUE('AL#WP7C' *CAT &WS3)
             CHGVAR     VAR(&AL#WP77) VALUE('AL#WP77' *CAT &WS3)
             CHGVAR     VAR(&AL#WP7L) VALUE('AL#WP7L' *CAT &WS3)

             CHGJOB     OUTQ(&PRTG)

             CHGVAR     VAR(&OUTR)  VALUE(0)
 #STP10:
      /*再発行データ*/
             CALL       PGM(AL#CD1) PARM(&OUTR)
      /*再発行データがあれば終了*/
             IF         COND(&OUTR *NE 0) THEN(GOTO CMDLBL(END))
 #STP20:
 #STP30:
      /*パレットチケット*/
             DLTF       FILE(&WLIB/&AL#WP46)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AL#WP46) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AL#WP46) +
                          OPTION(*NOLIST *NOSRC) SIZE(500 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AL#WP46) TOFILE(&WLIB/&AL#WP46)
             CALL       PGM(AL#R76) PARM(&P7FIXD &P7FIXT &P7TIMS &P7TRKB +
                          &P7IAFB)
             RTVMBRD    FILE(&WLIB/&AL#WP46) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(END))
 #STP40:
      /*かんばんデータ　*/
             DLTF       FILE(&WLIB/&AL#WP71)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AL#WP71) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AL#WP71) OPTION(*NOLIST *NOSRC) +
                          SIZE(5000 500 3) LVLCHK(*NO) AUT(*ALL)
      /*番地エラーデータ*/
             DLTF       FILE(&WLIB/&AL#WP77)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AL#WP77) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AL#WP77) OPTION(*NOLIST *NOSRC) +
                          SIZE(5000 500 3) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AL#WP71) TOFILE(&WLIB/&AL#WP71)
             OVRDBF     FILE(AL#WP77) TOFILE(&WLIB/&AL#WP77)
             CALL       PGM(AL#R77) PARM(&P7FIXD &P7FIXT &P7TRKB +
                          &P7IAFB)
             RTVMBRD    FILE(&WLIB/&AL#WP77) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)
             CALL       PGM(AL#R7I)
             ENDDO
          /*かんばんＳＥＱ＃セット*/
      /****  CALL       PGM(AL#R72)  ****/
          /*かんばんＳＥＱ＃AL#PP01へセット*/
      /****  CALL       PGM(AL#R79)  ****/
 #STP50:
      /*転送データ　　　*/
             DLTF       FILE(&WLIB/&AL#WP73)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AL#WP73) RCDLEN(0256) +
                          OPTION(*NOLIST *NOSRC) SIZE(500 5000 3) +
                          LVLCHK(*NO) AUT(*ALL)
             DLTF       FILE(&WLIB/&BL#WP73)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&BL#WP73) RCDLEN(0256) +
                          OPTION(*NOLIST *NOSRC) SIZE(500 5000 3) +
                          LVLCHK(*NO) AUT(*ALL)
             DLTF       FILE(&WLIB/&AL#WP7L)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AL#WP7L) RCDLEN(0256) +
                          OPTION(*NOLIST *NOSRC) SIZE(500 5000 3) +
                          LVLCHK(*NO) AUT(*ALL)
          /*チケットデータ　　　　*/
             OVRDBF     FILE(AL#WP46) TOFILE(&WLIB/&AL#WP46)
             OVRDBF     FILE(AL#WP73) TOFILE(&WLIB/&AL#WP73)
             CALL       PGM(AL#R73)
          /*かんばん仕分け枚数の計算*/
              /*かんばん枚数データ　*/
             DLTF       FILE(&WLIB/&AL#WP7C)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AL#WP7C) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AL#WP7C) OPTION(*NOLIST *NOSRC) +
                          SIZE(5000 500 3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AL#WP7C) TOFILE(&WLIB/&AL#WP7C)
             CALL       PGM(AL#R7D)
          /*かんばんデータ＋仕切り*/
             OVRDBF     FILE(AL#WP71) TOFILE(&WLIB/&AL#WP71)
             OVRDBF     FILE(AL#WP46) TOFILE(&WLIB/&AL#WP46)
             OVRDBF     FILE(AL#WP73) TOFILE(&WLIB/&AL#WP73)
             OVRDBF     FILE(AL#WP7L) TOFILE(&WLIB/&AL#WP7L)
          /*発行順マスターなし */
             CALL       PGM(AL#R7E)
          /* PALLET PULLING    */
             CALL       PGM(AL#R70)
          /* PALLET PULLING以外*/
             CALL       PGM(AL#R7F)
          /*発行漏れ防止                 */
          /*ここで抜かれるデータがあったらバグです*/
             CALL       PGM(AL#R7G)
          /*仕切りごとに再度並べ替え*/
             CALL       PGM(AL#R7L)
          /* BL#WP73=AL#WP73並べ替え前*/
             CPYF       FROMFILE(&WLIB/&AL#WP73) +
                          TOFILE(&WLIB/&BL#WP73) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             CPYF       FROMFILE(&WLIB/&AL#WP7L) +
                          TOFILE(&WLIB/&AL#WP73) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
          /*-----------------------------------*/
          /*かんばんＳＥＱ＃セット           */
          /*かんばんＳＥＱ＃AL#PP01へセット*/
          /*-----------------------------------*/
             CALL       PGM(AL#R7M)
          /*ページ、トータルセット　*/
             CALL       PGM(AL#R75)
          /*仕切りごとの箱数セット　*/
             CALL       PGM(AL#R7K)
 #STP55:
          /*発行実績              */
             CALL       PGM(AL#R7A) PARM(&P7FIXD &P7FIXT &P7TIMS &P7TRKB +
                          &P7IAFB)

 #STP60:
      /*転送データコピー*/
             DLTF       FILE(&WLIB/EDIDATA)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/EDIDATA) RCDLEN(0256) +
                          OPTION(*NOLIST *NOSRC) SIZE(500 5000 3) +
                          LVLCHK(*NO) AUT(*ALL)
             CPYF       FROMFILE(&WLIB/&AL#WP73) +
                          TOFILE(&WLIB/EDIDATA) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)

             DLTOVR     FILE(*ALL)

             CHGVAR     VAR(&OUTR) VALUE(1)
 #STP70:
 END:
             ENDPGM
