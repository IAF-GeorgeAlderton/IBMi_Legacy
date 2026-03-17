             PGM
             /*** AL#CCX ***********************************/
             /* TRUCK BIN M/F   **test**                   */
             /*  ITS.              2015.05.20              */
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
             DCL        VAR(&AL#WPC1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AL#WPC0) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P1KIHZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&P2KIHZ) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             CHGVAR     VAR(&WLIB) VALUE('TWFILE1 ')

             CHGVAR     VAR(&AL#WPC0) VALUE('AL#WPC0' *CAT &WS3)
             CHGVAR     VAR(&AL#WPC1) VALUE('AL#WPC1' *CAT &WS3)

             ADDLIBLE   LIB(TFILE1)
             ADDLIBLE   LIB(TWFILE1)
             RMVLIBLE   LIB(HFILE1)
             RMVLIBLE   LIB(HWFILE1)

             CHGJOB     OUTQ(&PRTG)
 #STP00:
      /*登録されているデータの切り替え日を一覧表示*/
             DLTF       FILE(&WLIB/&AL#WPC0)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AL#WPC0) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AL#WPC0) +
                          OPTION(*NOLIST *NOSRC) SIZE(500 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AL#WPC0) TOFILE(&WLIB/&AL#WPC0)
             CALL       PGM(AL#RC0)
      /*登録されているデータがない場合、新規追加*/
             RTVMBRD    FILE(&WLIB/&AL#WPC0) NBRCURRCD(&REC)
      /*     IF         COND(&REC *EQ 0) THEN(DO)         */
      /*     CHGVAR     VAR(&P1KIHZ) VALUE('00000000')    */
      /*     ENDDO                                        */
      /*     ELSE DO                                      */
      /*登録されているデータがなくても、選択画面*/
             CALL       PGM(AL#RC5) PARM(&P1KIHZ &PCMD)
             IF         COND(&PCMD *EQ '01') THEN(DO)
             GOTO       CMDLBL(END)
             ENDDO
 #STP10:
             DLTF       FILE(&WLIB/&AL#WPC1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AL#WPC1) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AL#WPC1) +
                          OPTION(*NOLIST *NOSRC) SIZE(500 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AL#WPC1) TOFILE(&WLIB/&AL#WPC1)
             CALL       PGM(AL#RC3) PARM(&P1KIHZ)
             CALL       PGM(AL#RC1) PARM(&P1KIHZ &PCMD)
             IF         COND(&PCMD *EQ '03') THEN(DO)
             GOTO       CMDLBL(#STP00)
             ENDDO
 #STP20:
             CALL       PGM(AL#RC4) PARM(&P1KIHZ)
       /*トラック便変更時に関連データ更新*/
             CALL       PGM(AL#RCA)
             GOTO       CMDLBL(#STP00)

 END:
             ADDLIBLE   LIB(HFILE1)
             ADDLIBLE   LIB(HWFILE1)
             RMVLIBLE   LIB(TFILE1)
             RMVLIBLE   LIB(TWFILE1)
             ENDPGM
