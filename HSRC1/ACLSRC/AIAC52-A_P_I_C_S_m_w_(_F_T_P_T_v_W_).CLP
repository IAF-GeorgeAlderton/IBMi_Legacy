             PGM       PARM(&LOCATION &PC_SYS &IHIZ &ITIM)
             /** AIAC52 ***********************************/
             /*  ＡＰＩＣＳシステム（ＦＴＰ通信処理）   */
             /*   マスター、かんばん発行データ送信      */
             /*                      2004.08.09 A.INOUE   */
             /*********************************************/
             /*   AIAC51 , AIAC52 は一緒に修正すること！*/
             /*********************************************/
             /*  &LOCATION  &PC_SYS       NOTES           */
             /* ﾜiｰﾆｭ]　システム区分 備考           */
             /*    9999        ZM        図面サーバー   */
             /*    0111        AP         AFS     発行機*/
             /************************* COPY FROM AIAC51 **/
             DCL        VAR(&LOCATION) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PC_SYS) TYPE(*CHAR) LEN(2)

             DCL        VAR(&FTP_LIB) TYPE(*CHAR) LEN(10)

             DCL        VAR(&ACTDTAARA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ENDJOBQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RQ_FILE) TYPE(*CHAR) LEN(10) /*PC->AS*/
             DCL        VAR(&AT_FILE) TYPE(*CHAR) LEN(10) /*PC->AS*/
             DCL        VAR(&HD_FILE) TYPE(*CHAR) LEN(10) /*AS->PC*/
             DCL        VAR(&EE_FILE) TYPE(*CHAR) LEN(10) /*AS->PC*/
             DCL        VAR(&RQ_TMP) TYPE(*CHAR) LEN(10) /*PC->AS*/
             DCL        VAR(&AT_TMP) TYPE(*CHAR) LEN(10) /*PC->AS*/
             DCL        VAR(&HD_TMP) TYPE(*CHAR) LEN(10) /*AS->PC*/
             DCL        VAR(&EE_TMP) TYPE(*CHAR) LEN(10) /*AS->PC*/
             DCL        VAR(&AS_SEND) TYPE(*CHAR) LEN(10) /*AS->PC*/
             DCL        VAR(&SERV_IP) TYPE(*CHAR) LEN(15) /*SERVER IP*/

             DCL        VAR(&PSTS) TYPE(*CHAR) LEN(1) /* STATUS */
             DCL        VAR(&PKFLG) TYPE(*CHAR) LEN(20) /* STATUS */
             DCL        VAR(&PFILE) TYPE(*CHAR) LEN(10) /* SEND FILE */
             DCL        VAR(&PSFLG) TYPE(*CHAR) LEN(1) /* SEND FLG */
             DCL        VAR(&PUALL) TYPE(*CHAR) LEN(116) /* FLG */

             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&WSOKK) TYPE(*DEC) LEN(4 0) VALUE(0)

             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WNBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&EJOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&IHIZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ITIM) TYPE(*CHAR) LEN(6)

             DCL        VAR(&MSG)     TYPE(*CHAR) LEN(150)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&WNBR)
             /*-----------------------------------*/
             /*  サーバー別利用ファイルのセット */
             /*-----------------------------------*/
             CHGVAR     VAR(&FTP_LIB) VALUE('APICSFTP')
             CHGVAR     VAR(&JOB) VALUE(&PC_SYS *CAT &LOCATION)
             CHGVAR     VAR(&EJOB) VALUE('E' *CAT &PC_SYS *CAT +
                          &LOCATION)

             /*-----------------------------------*/
             /*  サーバー別利用ファイルのセット */
             /*-----------------------------------*/
             CHGVAR     VAR(&ENDJOBQ) VALUE('E' *CAT &PC_SYS *CAT +
                          &LOCATION)
             CHGVAR     VAR(&RQ_FILE) VALUE('RQ' *CAT &LOCATION *CAT +
                          &PC_SYS)
             CHGVAR     VAR(&AT_FILE) VALUE('AT' *CAT &LOCATION *CAT +
                          &PC_SYS)
             CHGVAR     VAR(&HD_FILE) VALUE('HD' *CAT &LOCATION *CAT +
                          &PC_SYS)
             CHGVAR     VAR(&EE_FILE) VALUE('EE' *CAT &LOCATION *CAT +
                          &PC_SYS)
             CHGVAR     VAR(&RQ_TMP) VALUE('RQ' *CAT &LOCATION *CAT +
                          &PC_SYS *CAT 'E')
             CHGVAR     VAR(&AT_TMP) VALUE('AT' *CAT &LOCATION *CAT +
                          &PC_SYS *CAT 'E')
             CHGVAR     VAR(&HD_TMP) VALUE('HD' *CAT &LOCATION *CAT +
                          &PC_SYS *CAT 'E')
             CHGVAR     VAR(&EE_TMP) VALUE('EE' *CAT &LOCATION *CAT +
                          &PC_SYS *CAT 'E')
             CHGVAR     VAR(&AS_SEND) VALUE('AIAS' *CAT &PC_SYS *CAT +
                          &LOCATION)
             /*---------------------------*/
             /*  サーバー別ＩＰのセット */
             /*---------------------------*/
             IF         COND((&LOCATION *EQ '9999') *AND (&PC_SYS *EQ +
                          'ZM')) THEN(CHGVAR VAR(&SERV_IP) +
                          VALUE('10.1.1.100'))
             IF         COND((&LOCATION *EQ '0111') *AND (&PC_SYS *EQ +
                          'AP')) THEN(CHGVAR VAR(&SERV_IP) +
                          VALUE('10.1.1.100'))
             IF         COND((&LOCATION *EQ '0111') *AND (&PC_SYS *EQ +
                          'KT')) THEN(CHGVAR VAR(&SERV_IP) +
                          VALUE('10.1.1.100'))

              /* テスト機ＩＰアドレス */
      /*      CHGVAR VAR(&SERV_IP) VALUE('10.1.1.100') */


             /*--------------------------------*/
             /*  通信稼動データエリア作成    */
             /*--------------------------------*/
             CHGVAR     VAR(&ACTDTAARA) VALUE(&PC_SYS *CAT &LOCATION +
                          *CAT 'ACT')
             CRTDTAARA  DTAARA(&FTP_LIB/&ACTDTAARA) TYPE(*CHAR) +
                          LEN(10) TEXT('THE COMMUNICATIONS IS BEING +
                          EXECUTED')
             /*--------------------------------*/
             /*  通信プログラムのキャンセル  */
             /*--------------------------------*/
             CALL       PGM(ENDR01) PARM(&JOB &USER &WNBR &IHIZ +
                          &ITIM '          ' '          ' &IHIZ    +
                            &ITIM    'AIAC58    ' &LOCATION    +
                          &PC_SYS      &EJOB         'APICSCTL  ' +
                          'APICSCTL  ' '          ' '          ')

             /*************************************************/
             /* ファイルの初期化                            */
             /*************************************************/
 START:      DLTF       FILE(&FTP_LIB/&RQ_FILE)
             MONMSG   MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&FTP_LIB/&RQ_FILE) RCDLEN(256) +
                          TEXT('KEY_FILE_RQ') WAITFILE(60)
             DLTF       FILE(&FTP_LIB/&AT_FILE)
             MONMSG   MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&FTP_LIB/&AT_FILE) RCDLEN(256) +
                          TEXT('KEY_FILE_AT')  WAITFILE(60)
             DLTF       FILE(&FTP_LIB/&HD_FILE)
             MONMSG   MSGID(CPF3261 CPF2105)
             DLTF       FILE(&FTP_LIB/&EE_FILE)
             MONMSG   MSGID(CPF3261 CPF2105)


             /*******************/
             /*RQデータ確認 */
             /*******************/
 RQCHK:      CHKOBJ     OBJ(&FTP_LIB/&RQ_FILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTPF      FILE(&FTP_LIB/&RQ_FILE) RCDLEN(256) +
                          TEXT('KEY_FILE_RQ') WAITFILE(60)
             ENDDO

             RTVMBRD    FILE(&FTP_LIB/&AT_FILE) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(GOTO CMDLBL(ERRAT))

             RTVMBRD    FILE(&FTP_LIB/&RQ_FILE) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             DLYJOB     DLY(15)
             GOTO       RQCHK
             ENDDO
             /********************/
             /*ＡＴデータクリア*/
             /********************/
             DLTF       FILE(&FTP_LIB/&AT_FILE)
             MONMSG   MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&FTP_LIB/&AT_FILE) RCDLEN(256) +
                          TEXT('KEY_FILE_AT')  WAITFILE(60)
             /*******************/
             /*通信データ作成 */
             /*******************/
             /*   EBCDIC ---> ASCII  */
 RUN:        DLTF       FILE(&FTP_LIB/&RQ_TMP)
             MONMSG   MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&FTP_LIB/&RQ_TMP) RCDLEN(256) +
                          TEXT('KEY_FILE_RQ_TMP') WAITFILE(60)
             OVRDBF     FILE(INPUT) TOFILE(&FTP_LIB/&RQ_FILE)
             OVRDBF     FILE(OUTPUT) TOFILE(&FTP_LIB/&RQ_TMP)
             CALL       PGM(AIARCV) PARM('AE')
             DLTOVR     FILE(*ALL)

             DLTF       FILE(&FTP_LIB/&HD_TMP)
             MONMSG   MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&FTP_LIB/&HD_TMP) RCDLEN(256) +
                          TEXT('KEY_FILE_HD_TMP') WAITFILE(60)
             OVRDBF     FILE(INPUT) TOFILE(&FTP_LIB/&RQ_TMP)
             OVRDBF     FILE(OUTPUT) TOFILE(&FTP_LIB/&HD_TMP)
             CALL       PGM(AIAR51) PARM(&PSTS &LOCATION &PC_SYS +
                          &PKFLG &PFILE &PSFLG &PUALL)
             DLTOVR     FILE(INPUT)
             DLTOVR     FILE(OUTPUT)
             IF         COND(&PSTS *NE ' ') THEN(GOTO CMDLBL(ERROR))

             /*******************/
             /*HDデータ作成 */
             /*******************/
             DLTF       FILE(&FTP_LIB/&HD_FILE)
             MONMSG   MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&FTP_LIB/&HD_FILE) RCDLEN(256) +
                          TEXT('KEY_FILE_HD') WAITFILE(60)
             IF         COND(&PFILE *EQ '          ') THEN(DO)
             /* メッセージのみ送信EBCDIC --> ASCII */
             OVRDBF     FILE(INPUT) TOFILE(&FTP_LIB/&HD_TMP)
             OVRDBF     FILE(OUTPUT) TOFILE(&FTP_LIB/&HD_FILE)
             CALL       PGM(AIARCV) PARM('EA')
             DLTOVR     FILE(*ALL)
             ENDDO
             IF         COND(&PFILE *NE '          ') THEN(DO)
             /* 送信データあり*/
             OVRDBF     FILE(INPUT) TOFILE(&PFILE)
             OVRDBF     FILE(OUTPUT) TOFILE(&FTP_LIB/&HD_FILE)
             CALL       PGM(AIAR53) PARM(&PSTS &LOCATION &PC_SYS +
                          &PKFLG &PFILE &PSFLG &PUALL)
             DLTOVR     FILE(*ALL)
             IF         COND(&PSTS *NE ' ') THEN(GOTO CMDLBL(ERROR))
             ENDDO

             /*******************/
             /*EEデータ作成 */
             /*******************/
             DLTF       FILE(&FTP_LIB/&EE_TMP)
             MONMSG   MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&FTP_LIB/&EE_TMP) RCDLEN(256) +
                          TEXT('KEY_FILE_EE_TMP') WAITFILE(60)
             RTVMBRD    FILE(&FTP_LIB/&HD_FILE) NBRCURRCD(&REC)
             OVRDBF     FILE(OUTPUT) TOFILE(&FTP_LIB/&EE_TMP)
             CALL       PGM(AIAR54) PARM(&PSTS &REC)
             DLTOVR     FILE(*ALL)
             IF         COND(&PSTS *NE ' ') THEN(GOTO CMDLBL(START))
             /* EBCDIC --> ASCII */
             DLTF       FILE(&FTP_LIB/&EE_FILE)
             MONMSG   MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&FTP_LIB/&EE_FILE) RCDLEN(256) +
                          TEXT('KEY_FILE_EE') WAITFILE(60)
             OVRDBF     FILE(INPUT) TOFILE(&FTP_LIB/&EE_TMP)
             OVRDBF     FILE(OUTPUT) TOFILE(&FTP_LIB/&EE_FILE)
             CALL       PGM(AIARCV) PARM('EA')
             DLTOVR     FILE(*ALL)

             /***********************/
             /*AS=>PCデータ送信 */
             /***********************/
             IF         COND(&PSFLG *NE '*') THEN(GOTO CMDLBL(START))
             CALL       PGM(AIAC55) PARM(&PSTS &SERV_IP &AS_SEND)
             IF         COND(&PSTS *NE ' ') THEN(DO)
                CALL       PGM(AIAR50) PARM('A4' &LOCATION &PC_SYS +
                          &PKFLG &PUALL)
                GOTO       CMDLBL(ERROR)
             ENDDO
             /*******************/
             /*ATデータ確認 */
             /*******************/
             CHGVAR     VAR(&WSOKK) VALUE(0)
 ATCHK:      DLYJOB     DLY(3)
             CHKOBJ     OBJ(&FTP_LIB/&AT_FILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTPF      FILE(&FTP_LIB/&AT_FILE) RCDLEN(256) +
                          TEXT('KEY_FILE_AT') WAITFILE(60)
             ENDDO

             RTVMBRD    FILE(&FTP_LIB/&AT_FILE) NBRCURRCD(&REC)
             IF         COND(&WSOKK *GE 60) THEN(DO)
             CALL       PGM(AIAR50) PARM('A3' &LOCATION &PC_SYS +
                          &PKFLG &PUALL)
             CHGVAR     VAR(&PSTS) VALUE('E')
             GOTO       ERROR
             ENDDO
             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&WSOKK) VALUE(&WSOKK+1)
             GOTO       ATCHK
             ENDDO
  /********/
             /*******************/
             /*ATデータ確認 */
             /*******************/
             /*   EBCDIC ---> ASCII  */
             DLTF       FILE(&FTP_LIB/&AT_TMP)
             MONMSG   MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&FTP_LIB/&AT_TMP) RCDLEN(256) +
                          TEXT('KEY_FILE_AT_TMP') WAITFILE(60)
             OVRDBF     FILE(INPUT) TOFILE(&FTP_LIB/&AT_FILE)
             OVRDBF     FILE(OUTPUT) TOFILE(&FTP_LIB/&AT_TMP)
             CALL       PGM(AIARCV) PARM('AE')
             DLTOVR     FILE(*ALL)

             OVRDBF     FILE(INPUT) TOFILE(&FTP_LIB/&AT_TMP)
             CALL       PGM(AIAR52) PARM(&PSTS &LOCATION &PC_SYS +
                          &PKFLG &PFILE &PUALL)
             DLTOVR     FILE(INPUT)
             IF         COND(&PSTS *NE ' ') THEN(GOTO CMDLBL(ERROR))

             GOTO       START

 ERRAT:
             /*************************************/
             /*RQ前のATデータエラーログ出力 */
             /*************************************/
             /*   EBCDIC ---> ASCII  */
             DLTF       FILE(&FTP_LIB/&AT_TMP)
             MONMSG   MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&FTP_LIB/&AT_TMP) RCDLEN(256) +
                          TEXT('KEY_FILE_AT_TMP') WAITFILE(60)
             OVRDBF     FILE(INPUT) TOFILE(&FTP_LIB/&AT_FILE)
             OVRDBF     FILE(OUTPUT) TOFILE(&FTP_LIB/&AT_TMP)
             CALL       PGM(AIARCV) PARM('AE')
             DLTOVR     FILE(*ALL)

             OVRDBF     FILE(INPUT) TOFILE(&FTP_LIB/&AT_TMP)
             CALL       PGM(AIAR58) PARM(&PSTS &LOCATION &PC_SYS)
             DLTOVR     FILE(INPUT)
             IF         COND(&PSTS *NE ' ') THEN(GOTO CMDLBL(ERROR))

             DLTF       FILE(&FTP_LIB/&AT_FILE)
             MONMSG   MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&FTP_LIB/&AT_FILE) RCDLEN(256) +
                          TEXT('KEY_FILE_AT')  WAITFILE(60)

             GOTO       RQCHK

 ERROR:
             IF         COND(&PSTS *NE 'E') THEN(GOTO CMDLBL(START))
             CHGVAR     VAR(&MSG) VALUE('ABNORMALITY WAS DETECTED BY +
                          THE A-PICS COMMUNICATION. PLEASE CONTACT +
                          THE PERSON IN CHARGE AT ONCE')
              CHGVAR     VAR(%SST(&MSG  78 4)) VALUE(&LOCATION)
              CHGVAR     VAR(%SST(&MSG  98 2)) VALUE(&PC_SYS)

             SNDPGMMSG  MSG(&MSG) TOMSGQ(QSYSOPR) MSGTYPE(*INFO)

             GOTO       START

 ENDCL:      ENDPGM
