             PGM
             /*** AAMCB0 *****************************/
             /*  指定工程コード品番リスト（ＣＳＶ）*/
             /*      KIRI         2010.09.24         */
             /********************* COPY BY AAMC35 ***/
             DCLF       FILE(AAMPWB0)

             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)

             DCL        VAR(&MBAN)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&REC)   TYPE(*DEC) LEN(10 0) VALUE(0)


             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 3))
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

          /*----------------------------------------------------*/
          /*重複処理制御ファイルチェック＆作成                */
          /*----------------------------------------------------*/
             CHKOBJ     OBJ(AAMCB0ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@EXE))
 @MSG01:
             SNDPGMMSG  MSG('( G ) +
                    指定工程コード品番リスト（ＣＳＶ）を他端末で+
                          行なっていますので、しばらくお待ち下さい+
                          。＜Ｇで実行＞') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND(&KOTAE *NE 'G') THEN(GOTO CMDLBL(@MSG01))
             GOTO       CMDLBL(@END)

 @EXE:
             CRTDTAARA  DTAARA(AAMCB0ACT) TYPE(*CHAR) +
                          LEN(10) AUT(*ALL)


 STEP1:      SNDRCVF    RCDFMT(DSP01)
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&IN91) VALUE('0')
             CHGVAR     VAR(&IN92) VALUE('0')
             CHGVAR     VAR(&IN93) VALUE('0')
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(#END))

             IF         COND(&KYY *EQ 0) THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN92) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('年を入力して下さい')
             GOTO STEP1
             ENDDO
             IF         COND((&KMM *LT 1) *OR (&KMM *GT 12)) THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN93) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('月を正しく入力して下さい')
             GOTO STEP1
             ENDDO

             IF         COND((&KT *EQ '   ') *AND (&BM *EQ '    ')) +
                          THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN91) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('どちらかを入力して下さい')
             GOTO STEP1
             ENDDO
             IF         COND(&IN05 *NE '1') THEN(GOTO CMDLBL(STEP1))

             DLTF       FILE(AAMWPB0)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AAMWPB0) RCDLEN(2048)

             CALL       PGM(AAMRB0) PARM(&KYY &KMM &KT &KT2 &KT3 &BM)

             RTVMBRD    FILE(HWFILE1/AAMWPB0) NBRCURRCD(&REC)
             IF         COND(&REC *LE 1) THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN91) VALUE('1')
             CHGVAR     VAR(&IN92) VALUE('1')
             CHGVAR     VAR(&IN93) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('対象のデータがありません。')
             GOTO STEP1
             ENDDO

  /*         STRPCO     PCTA(*NO)                                   */
  /*         MONMSG     MSGID(CPF0000)                              */
  /*         STRPCCMD   PCCMD('"C:$PROGRAM FILES$PERSONAL +         */
  /*                      COMMUNICATIONS$PCSFT5.EXE" +              */
  /*                      C:$AS400$TTO$AAMWPB0IAF.TTO') PAUSE(*NO)  */

             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD('"C:/PROGRAM FILES/IBM/CLIENT +
                          ACCESS/RTOPCB.EXE" +
                          C:/AS400/TTO/AAMWPB0IAF.DTF') PAUSE(*NO)

             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD('"C:/PROGRAM FILES (X86)/IBM/CLIENT +
                          ACCESS/RTOPCB.EXE" +
                          C:/AS400/TTO/AAMWPB0IAF.DTF') PAUSE(*NO)

 #END:
             DLTDTAARA  DTAARA(AAMCB0ACT)
 @END:
             ENDPGM
