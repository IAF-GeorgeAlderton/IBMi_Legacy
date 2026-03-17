             PGM
             /** MYBC01 ******************************/
             /*  熱処理引当品リスト作成（ＣＳＶ）  */
             /*      MSK          2008.06.06         */
             /*                                      */
             /*  I-HASADA 2013/04/03                 */
             /*   COPY RPG(IAFAYM):CA035C            */
             /****************************** MYBC01 **/
             DCLF       FILE(MYBPW01)
             DCL        VAR(&KT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&BM) TYPE(*CHAR) LEN(4) VALUE('    ')
             DCL        (&IN91) TYPE(*LGL) LEN(1)
             DCL        (&IN99) TYPE(*LGL) LEN(1)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS04) TYPE(*CHAR) LEN(4)
/* TCHK1 */  DCL        VAR(&WS01) TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PIPGMN) TYPE(*CHAR) LEN(10) +
                          VALUE('MYBC01    ')
             DCL        VAR(&POWSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POUSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POKONA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POSTTS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGTXT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)

             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&WS04) VALUE(%SST(&WSID 1 4))
/* TCHK1 */  CHGVAR     VAR(&WS01) VALUE(%SST(&WSID 1 1))

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

          /*----------------------------------------------------*/
          /* CHECK AND REGISTER  */
          /*     POSTTS = '1' CAN PROCESS                       */
          /*            = '2' OTHER WS IS PROCESSING            */
          /*----------------------------------------------------*/
             CALL       PGM(APLR80) PARM(&PIPGMN &POWSID &POUSID +
                          &POKONA &POSTTS)
             IF         COND(&POSTTS *EQ '1') THEN(GOTO CMDLBL(@PGM))

             CHGVAR     VAR(&MSGTXT) VALUE('(G) ' *CAT &POUSID *CAT +
                          ' ' *CAT &POKONA *TCAT ' IS USING AT ' +
                          *CAT &POWSID *TCAT '* NOW. PLEASE TRY +
                          AGAIN LATER.')
 STP1:
             CHGVAR     VAR(&PKINP) VALUE('G    ')
             CHGVAR     VAR(&PKOUT) VALUE(' ')
             CALL       PGM(AJGR11) PARM(&MSGTXT &PKINP &WSID &PKOUT)
             IF         (&PKOUT *EQ 'G') GOTO @END

 @PGM:
             CHGVAR     VAR(&HOSEI) VALUE(100)
 STEP1:      SNDRCVF    RCDFMT(MYBPW011)
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&IN91) VALUE('0')
             CHGVAR     VAR(&IN92) VALUE('0')
             CHGVAR     VAR(&IN93) VALUE('0')
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(#END))

             IF         COND(&KYY *EQ 0) THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN92) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT YEAR')
             GOTO STEP1
             ENDDO
             IF         COND((&KMM *LT 1) *OR (&KMM *GT 12)) THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN93) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT CORRECT MONTH')
             GOTO STEP1
             ENDDO

             IF         COND((&KT *EQ '   ') *AND (&BM *EQ '    ')) +
                          THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN91) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT EITHER ONE')
             GOTO STEP1
             ENDDO
             IF         COND((&HOSEI *LE 0) *OR (&HOSEI *GT 999)) +
                          THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN94) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('RANGE IS 0% - 999%')
             GOTO STEP1
             ENDDO
             IF         COND(&IN05 *NE '1') THEN(GOTO CMDLBL(STEP1))

             DLTF       FILE(MYBWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/MYBWP01) RCDLEN(2048) +
                          TEXT('PARTS LIST EXCEL DATA') +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(MYBR01) PARM(&KYY &KMM &KT &KT2 &KT3 &BM +
                          &HOSEI)

             RTVMBRD    FILE(HWFILE1/MYBWP01) NBRCURRCD(&REC)
             IF         COND(&REC *LE 1) THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN91) VALUE('1')
             CHGVAR     VAR(&IN92) VALUE('1')
             CHGVAR     VAR(&IN93) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('NO DATA.')
             GOTO STEP1
             ENDDO

             CALL       PGM(TSKC90)

             /*P-COM-------------------------------------------*/
             IF         COND((&WS01 *EQ 'Y') *OR +
                             (&WS01 *EQ 'W') *OR +
                             (&WS01 *EQ 'Z') *OR +
                             (&WS01 *EQ 'Q')) THEN(DO)
             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD('"C:/PROGRAM FILES (X86)/PERSONAL +
                          COMMUNICATIONS/PCSFT5.EXE" +
                          C:/AS400/TTO/MYBWP01.TTO') PAUSE(*NO)
             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD('"C:/PROGRAM FILES/PERSONAL +
                          COMMUNICATIONS/PCSFT5.EXE" +
                          C:/AS400/TTO/MYBWP01.TTO') PAUSE(*NO)
             ENDDO
             /*------------------------------------------------------*/

             /* CLIENT ACCESS------------------------------*/
             IF         COND((&WS01 *NE 'Y') *AND +
                             (&WS01 *NE 'W') *AND +
                             (&WS01 *NE 'Z') *AND +
                             (&WS01 *NE 'Q')) THEN(DO)
             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD('"C:/PROGRAM FILES (X86)/IBM/CLIENT +
                          ACCESS/RTOPCB.EXE" +
                          C:/AS400/TTO/MYBWP01.DTF') PAUSE(*NO)
             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD('"C:/PROGRAM FILES/IBM/CLIENT +
                          ACCESS/RTOPCB.EXE" +
                          C:/AS400/TTO/MYBWP01.DTF') PAUSE(*NO)
             ENDDO
             /*------------------------------------------------------*/

 #END:
        /*--------------------------------*/
        /* %0002  UNLOCK MULTIPLE CONTROL */
        /*--------------------------------*/
             CALL       PGM(APLR81) PARM(&PIPGMN)
 @END:
             ENDPGM
