             PGM
             /** GDSC02 ***************************************/
             /* IAF INVOICE NO. CHANGING BY CSV FILE FOR DIES */
             /*                                  FOR PARTS    */
             /*     NAMSU.KIM                     2022.05.17  */
             /************************************* GDSC01 ****/
             DCLF       FILE(GDSPW02)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&PIPGMN) TYPE(*CHAR) LEN(10) +
                          VALUE('GDSC02    ')
             DCL        VAR(&POUSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POKONA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POSTTS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGTXT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&REC)  TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&REC1)  TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&TOK)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&PSTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CMD1) TYPE(*CHAR) LEN(90)
             DCL        VAR(&CMD2) TYPE(*CHAR) LEN(90)
             DCL        VAR(&CMD3) TYPE(*CHAR) LEN(90)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 2))
          /* CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)             */
          /* CHGJOB     OUTQ(&PRTG)                                          */

STP0:
          /*----------------------------------------------------*/
          /*重複処理制御ファイルチェック＆作成                */
          /*     POSTTS = '1' 実行可能                        */
          /*            = '2' 他で処理中                      */
          /*----------------------------------------------------*/
          /* CALL       PGM(AA800R) PARM(&PIPGMN &POUSID &POKONA +           */
          /*              &POSTTS)                                           */
          /* IF         COND(&POSTTS *EQ '1') THEN(GOTO CMDLBL(STP1))        */
          /* CHGVAR     VAR(&MSGTXT) +                                       */
          /*              VALUE('他の端末で処理中。しばらく待てください。+ */
          /*              　　　　　　　　　　　　　　　　　　　　　　 +   */
          /*              ※作業者' *CAT &POUSID *CAT &POKONA *CAT +       */
          /*              '【応答＝Ｇ】')                                  */
          /* CHGVAR     VAR(&PKINP) VALUE('G    ')                           */
          /* CHGVAR     VAR(&PKOUT) VALUE(' ')                               */
          /* CALL       PGM(AB800R) PARM(&MSGTXT &PKINP &WSID &PKOUT)        */
          /* IF         COND(&PKOUT *EQ 'G') THEN(GOTO CMDLBL(END2))         */

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(GDSPW021)
          /*-----------*/
          /*   CMD- 1  */
          /*-----------*/
             IF         COND(&IN01 *EQ '1') THEN(DO)
                  GOTO END
             ENDDO
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&@ERR) VALUE(*BLANK)

             IF (&@SIRE *EQ '    ')  DO
             CHGVAR     VAR(&IN05) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN31) VALUE('1')
             CHGVAR     VAR(&@ERR) VALUE('海外拠点コードを+
                        入力してください。')
             GOTO       CMDLBL(STP1)
             ENDDO

             IF (&@SIRE *EQ '0000')  DO
             CHGVAR     VAR(&IN05) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN31) VALUE('1')
             CHGVAR     VAR(&@ERR) VALUE('海外拠点コードを+
                        入力してください。')
             GOTO       CMDLBL(STP1)
             ENDDO

          /*-----------*/
          /*   CMD- 5  */
          /*-----------*/
             IF (&IN05 *EQ '1') DO
             GOTO       CMDLBL(STP2)
             ENDDO

             GOTO       CMDLBL(STP1)
STP2:
          /*----------------------------------------------*/
          /* CSV FILE INPUT FROM USER PC TO AS400         */
          /*----------------------------------------------*/
             CLRPFM     FILE(GDSWP02)

             DLTF       FILE(HWFILE1/GDSWP02X)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/GDSWP02X) RCDLEN(1024) +
                          IGCDTA(*YES) OPTION(*NOLIST) SIZE(50000 +
                          10000 3) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(HWFILE1/GDSWP02E)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/GDSWP02E) RCDLEN(1024) +
                          IGCDTA(*YES) OPTION(*NOLIST) SIZE(50000 +
                          10000 3) LVLCHK(*NO) AUT(*ALL)

          /* FOR WIN10 */
             CHGVAR     VAR(&CMD3) VALUE('"C:$PROGRAM +
                          FILES (X86)$IBM$CLIENT ACCESS$+
                        RFROMPCB.EXE" +
                          C:$AS400$DTT$GDSWP02X.DTT')

             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD(&CMD3) PAUSE(*NO)
             DLYJOB     DLY(3)

          /* FOR WIN7 */
             CHGVAR     VAR(&CMD2) VALUE('"C:$PROGRAM +
                          FILES$IBM$CLIENT ACCESS$RFROMPCB.EXE" +
                          C:$AS400$DTT$GDSWP02X.DTT')

             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD(&CMD2) PAUSE(*NO)
             DLYJOB     DLY(3)
STP3:
          /*----------------------------------------------*/
          /*CHECING INPUT DATA(CSV FILE)                  */
          /*----------------------------------------------*/
             CPYFRMIMPF FROMFILE(HWFILE1/GDSWP02X) +
                          TOFILE(HWFILE1/GDSWP02) FROMRCD(2) +
                          ERRRCDFILE(HWFILE1/GDSWP02E) +
                          RPLNULLVAL(*FLDDFT)
             MONMSG     MSGID(CPF2817)

             CHGVAR     VAR(&REC1) VALUE(0)
             RTVMBRD    FILE(GDSWP02E) NBRCURRCD(&REC1)
             IF         COND(&REC1 *NE 0) THEN(DO)
             CHGVAR     VAR(&@ERR) +
                          VALUE('PLEASE CHECK CSV FILE.')
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       CMDLBL(STP1)
             ENDDO

             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(GDSWP02) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&@ERR) +
                          VALUE('CSV FILE UPLOADING WAS FAILED. +
                          PLEASE TRY IT AGAIN.')
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       CMDLBL(STP1)
             ENDDO

             CHGVAR     VAR(&PSTS) VALUE(' ')
             CALL       PGM(GDSR02) PARM(&@SIRE)


 END:
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF3261 CPF2105)

        /*   CALL       PGM(AA801R) PARM(&PIPGMN)   */

 END2:
             ENDPGM
