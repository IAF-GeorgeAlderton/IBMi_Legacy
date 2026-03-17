             PGM
             /** ABMC61 ************************/
             /* AUTO SETTING                   */
             /*   HOTTA.           2018.06.12  */
             /**********************************/
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
             DCL        VAR(&P@NTYM) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&P@ERR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ABMWP60) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWP11) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWP21) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWP30) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWP31) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWP23) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWP27) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AEXWP15) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWP16) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P1KIHZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG@) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM  ) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)
             CHGVAR     VAR(&PGM ) VALUE('ABMC61N ')

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO
             CHGVAR     VAR(&ABMWP60) VALUE('ABMWP60')
             CHGVAR     VAR(&ABMWP11) VALUE('ABMWP11')
             CHGVAR     VAR(&ABMWP21) VALUE('ABMWP21')
             CHGVAR     VAR(&ABMWP30) VALUE('ABMWP30')
             CHGVAR     VAR(&ABMWP31) VALUE('ABMWP31')
             CHGVAR     VAR(&AEXWP15) VALUE('AEXWP15')
             CHGVAR     VAR(&ABMWP16) VALUE('ABMWP16')
             CHGVAR     VAR(&ABMWP23) VALUE('ABMWP23')
             CHGVAR     VAR(&ABMWP27) VALUE('ABMWP27')

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
 STP00:
             CRTDTAARA  DTAARA(&WLIB/AAVACT) TYPE(*CHAR) LEN(10) +
                          TEXT('PART INFORMATION M/F UPDATE +
                          HANDLING') AUT(*ALL)
             MONMSG     MSGID(CPF1023) EXEC(DO)
 STP2:
             SNDPGMMSG  MSG('( G ) KANBAN M/F LIST HANDLING OR +
                          PROD ORDER BOOK MAKING  HANDLING OR +
                          INTRA-PROCESS LOCATION CODE M/F IS +
                          ACTIVE, WAIT FOR A WHILE') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         COND((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) +
                          THEN(GOTO CMDLBL(STP2))
             GOTO       CMDLBL(END)
             ENDDO
 STP10:
      /*--------------------- */
      /* DISPLAY SCREEN       */
      /*--------------------- */
             CALL       PGM(ABMR10) PARM(&P@NTYM &PCMD &PRTG@)
             IF         COND(&PCMD *EQ '01') THEN(GOTO CMDLBL(#END))

      /*--------------------- */
      /* TAKE BACKUP          */
      /*--------------------- */
             CALL       PGM(ABMC62)

      /*--------------------- */
      /* UPDATE FORECAST FILE */
      /*--------------------- */
      /* UPDATE ABBPP01 */
             CALL       PGM(ABMC50) PARM(&P@ERR &PRTG@)
             IF         COND(&P@ERR *EQ '9') THEN(GOTO CMDLBL(#END))

      /*--------------------- */
      /*出荷Ｍなしリスト    */
      /* NO SHIPPING M/F LIST */
      /*--------------------- */
             CALL       PGM(ABMC51) PARM(&P@NTYM &PRTG@)

      /*--------------------- */
       /*部品Ｍなしリスト   */
       /* NO PART M/F LIST    */
      /*--------------------- */
             CALL       PGM(ABMC54) PARM(&P@NTYM &PRTG@)

      /*------------------------------------------------------ */
      /*内示を使用しないユーザーは得・納・社内品番で集約する */
      /* SUMMARY CUSTOMER THAT DOES NOT USE FORECAST           */
      /*  BY CUSTOMER CODE AND PARTS                           */
      /*------------------------------------------------------ */
             DLTF       FILE(&WLIB/&ABMWP60)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWP60) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABMWP60) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(ABMWP60) TOFILE(&WLIB/&ABMWP60)

       /* ABBPP01 -> ABMWP60 */
             CALL       PGM(ABMR60) PARM(&P@NTYM)

      /*--------------------- */
      /* ALL PARTS            */
      /*--------------------- */
             DLTF       FILE(&WLIB/&ABMWP11)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWP11) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABMWP11) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(ABMWP60) TOFILE(&WLIB/&ABMWP60)
             OVRDBF     FILE(ABMWP11) TOFILE(&WLIB/&ABMWP11)

       /* FCEPP01 -> ABMWP11 */
             CALL       PGM(ABMR61) PARM(&P@NTYM)

      /*-------------------------------*/
      /*構成品でFCEPP01にもある品番*/
      /* COMPOMENT PARTS IN FCEPP01    */
      /*-------------------------------*/
       /* MCENP13 -> ABMWP11 */
             CALL       PGM(ABMR68) PARM(&P@NTYM)

      /*-------------------------------*/
      /* SUMMARY ABMWP11               */
      /*-------------------------------*/
             DLTF       FILE(&WLIB/&ABMWP21)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWP21) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABMWP21) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(ABMWP21) TOFILE(&WLIB/&ABMWP21)

       /* ABMWP11 -> ABMWP21 */
             CALL       PGM(ABMR13)

      /*----------------------------------------*/
      /* CHECK IMPORT UNIT PRICE M/F & ABBPP50  */
      /*----------------------------------------*/
             DLTF       FILE(&WLIB/&ABMWP23)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWP23) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABMWP23) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)
             DLTF       FILE(&WLIB/&ABMWP27)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWP27) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABMWP27) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(ABMWP23) TOFILE(&WLIB/&ABMWP23)
             OVRDBF     FILE(ABMWP27) TOFILE(&WLIB/&ABMWP27)

       /* ABMWP21 <-> ABMWP23  IMPORT UNIT PRICE M/F */
       /*          -> ABMWP27  BUILD OUT  */
             CALL       PGM(ABMR27)

      /*----------------------------------*/
      /* RE-CALCULATE PT PARTS SETTING #  */
      /*----------------------------------*/
       /* UPDATE ABMWP21 */
             CALL       PGM(ABMR28)

      /*-------------------------------*/
      /* UPDATE ABMWP21 BY DUMMY FILES */
      /*-------------------------------*/
      /* OMIT FLAG(ABMWP21) KMAX OVER 999          */
      /* DUMMY UPDATE FCEPP01   FCEPP11   GHCPP21  */
      /*             (FCFPP01) (FCFPP11) (GHDPP21) */
             CALL       PGM(ABMC63)

      /*-------------------------------*/
      /* ACUMULATE ABMWP11             */
      /*-------------------------------*/
       /* ABMWP11 -> ABMPP11 */
             CALL       PGM(ABMR12)

      /*-------------------------------*/
      /* ACUMULATE ABMWP21             */
      /*-------------------------------*/
       /* ABMWP21 -> ABMPP21 */
             CALL       PGM(ABMR14)

      /*----------------------------------*/
      /* UPDATE FCEPP01,FCEPP11,GHCPP21   */
      /*----------------------------------*/
             DLTF       FILE(&ABMWP16)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWP16) RCDLEN(12) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             OVRDBF     FILE(ABMWP16) TOFILE(&WLIB/&ABMWP16)

       /* ABMWP21 <-> FCEPP01 */
       /*         <-> FCEPP11 */
       /*         <-> GHCPP21 */
       /*          -> ABMWP16 */
             CALL       PGM(ABMR15)

      /*----------------------------------*/
      /* UPDATE  GHCPP21                  */
      /*----------------------------------*/
             CALL       PGM(ABMR1E)

      /*----------------------------------*/
      /* UPDATE  PROCESS M/F              */
      /*----------------------------------*/
       /* ABMWP21 <-> AAMPP11 */
       /* GHCPP21             */
             CALL       PGM(ABMR16)

      /*----------------------------------*/
      /* UPDATE  COMPONENT PART # M/F     */
      /*----------------------------------*/
       /* FCEPP01  <-> AEBPP01 */
             CALL       PGM(AEXR01)

      /*-------------------------------------------*/
      /* UPDATE  COMPONENT PART MONTHLY QTY FILE   */
      /*-------------------------------------------*/
             DLTF       FILE(&WLIB/&AEXWP15)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AEXWP15) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AEXWP15) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AEXWP15) TOFILE(&WLIB/&AEXWP15)

       /* AEBPP01  <-> AEBPP11 */
       /*           -> AEXWP15 */
             CALL       PGM(AEXR02)

      /*----------------------------------------*/
      /* UPDATE  COMPONENT PART INFORMATION M/F */
      /*----------------------------------------*/
       /* AEBPP11  <-> AKCPP01 */
             CALL       PGM(AEXR03)

      /*----------------------------------------*/
      /* UPDATE  COMPONENT PART # PROCESS M/F   */
      /*----------------------------------------*/
       /* AKCPP01   -> AKDPP01 */
             CALL       PGM(AEXR04)

      /*----------------------------------------*/
      /* UPDATE  COMPONENT KANBAN CHNGE M/F     */
      /*----------------------------------------*/
       /* AKDPP01   -> AKEPP01 */
             CALL       PGM(AEXR05)

      /*================================================*/
      /* UPDATE KANBAN MASTER                           */
      /*================================================*/
             DLTF       FILE(&WLIB/&ABMWP30)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWP30) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABMWP30) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)
             DLTF       FILE(&WLIB/&ABMWP31)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWP31) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABMWP31) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(ABMWP30) TOFILE(&WLIB/&ABMWP30)
             OVRDBF     FILE(ABMWP31) TOFILE(&WLIB/&ABMWP31)

           /* AAFPP01   PLATING KANBAN  */
             CALL       PGM(ABMR21)

           /* AAHPP01   PART WITHDRAWAL */
             CALL       PGM(ABMR22)

           /* ABHPP01   PRODUCTION      */
             CALL       PGM(ABMR25)

           /* ADHPP01   HEAT TREATMENT  */
             CALL       PGM(ABMR26)

           /* AAPPP01   FINISHED PARTS  */
             CALL       PGM(ABMR23)

           /* AANPP01   HALF FINISHED PARTS */
             CALL       PGM(ABMR24)

           /* AKBPP01   COMPONENT PART */
             CALL       PGM(AEXR11) PARM(&P@NTYM)


           /* IZAPP10   FINISHED MATERIAL MOTHLY QTY */
             CALL       PGM(FCER9E)

           /* IZAPP01   FINISHED MATERIAL KANBAN M/F */
             CALL       PGM(FCER9F)

      /*----------------------------------------*/
      /* WRITE ABMPP00   PROCESS LOG            */
      /*----------------------------------------*/
      /*JW** CALL       PGM(ABMR19) PARM(&P@NTYM)    **/
             CALL       PGM(ABMR19A) PARM(&P@NTYM &PGM)

      /*----------------------------------------*/
      /* ACUMULATE  KANBAN M/F UPDATE RESULTS   */
      /*----------------------------------------*/
       /* ABMWP31   -> ABMPP31 */
             CALL       PGM(ABMR31) PARM(&P@NTYM)

      /*----------------------------------------*/
      /* UPDATE PT PLAN PUBLICATION M/F         */
      /* CREATE PT PLAN SCHEDULE(CSV)  FOR ASJ  */
      /*  計画発行データ・ＡＳＪ送付用ＣＳＶ  */
      /*----------------------------------------*/
             CALL       PGM(BTDC00)

      /*================================================*/
      /* NON UPDATE LIST                                */
      /*================================================*/
      /*  更新なしリスト（ＰＴ） PT PARTS     */
             CALL       PGM(ABMC70) PARM(&P@NTYM &PRTG@)

      /*  更新なしリスト（ＢＰＴ）BPT PARTS   */
             CALL       PGM(ABMC72) PARM(&P@NTYM &PRTG@)

      /*  更新なしリスト（構成品）COMPONENT PARTS   */
       /***  CALL       PGM(ABMC73) PARM(&P@NTYM)  ***/

      /* 更新なしリスト（ＡＢＭＰＰ８１登録あり）*/
      /* NON UPDATE LIST REGISTERED IN ABMPP81  */
             CALL       PGM(ABMC75) PARM(&P@NTYM &PRTG@)

      /*  更新なしリスト（立上日６ヶ月）        */
      /* NEW PARTS STARTED WITHIN 6 MONTHS */
             CALL       PGM(ABMC77) PARM(&P@NTYM &PRTG@)

      /*更新なしリスト（３ヶ月以内設定数更新）  */
      /* UPDATED SETTING # WITHIN 3 MONTHS  */
             CALL       PGM(ABMC78) PARM(&P@NTYM &PRTG@)

      /*  ＭＡＸ＞９９９または収容数ゼロ */
      /*  # OF KABAN EXCEEDS 999 OR  0 QTY */
             CALL       PGM(ABMC79) PARM(&P@NTYM &PRTG@)

      /*今回設定数２０*/
      /*  NEW MONTHLY SETTING # IS 20. */
             CALL       PGM(ABMC7B) PARM(&P@NTYM &PRTG@)

      /*現在設定数２０*/
      /*  CURRENT MONTHLY SETTING # IS 20. */
             CALL       PGM(ABMC7C) PARM(&P@NTYM &PRTG@)

      /* NOT IN IMPORT UNIT PRICE M/F      */
             CALL       PGM(ABMC7F) PARM(&P@NTYM &PRTG@)

      /* BUILD OUT PART NO.  */
             CALL       PGM(ABMC7G) PARM(&P@NTYM &PRTG@)

      /*================================================*/
      /* UPDATE RESULT LIST                             */
      /*================================================*/
      /*設定数変更A-PICS */
             CALL       PGM(ABMC33) PARM(&P@NTYM &PRTG@)

      /*設定数変更EXCEPT A-PICS */
             CALL       PGM(ABMC34) PARM(&P@NTYM &PRTG@)

      /*ロット変更 LOT CHANGE */
             CALL       PGM(ABMC35) PARM(&P@NTYM &PRTG@)

      /*間口数変更 LOCATION SIZE CHANGE */
             CALL       PGM(ABMC36) PARM(&P@NTYM &PRTG@)

      /* SHIPMENT OVERLAP */
             CALL       PGM(ABMC37) PARM(&P@NTYM &PRTG@)

      /*内示異常リストABMPP01のユーザーのみ ２つめのパラメータ１*/
      /* ABNORMAL FORECAST LIST FOR EXISTING IN ABMPP01 */
             CALL       PGM(ABMCA0) PARM(&P@NTYM '1' &PRTG@)

      /*内示異常リスト　全ユーザー ２つめのパラメータ　ブランク*/
      /* ABNORMAL FORECAST LIST FOR ALL CUSTOMERS */
             CALL       PGM(ABMCA0) PARM(&P@NTYM ' ' &PRTG@)

      /*材料かんばん変更リスト MATERIAL KANBANN CHANGE LIST */
      /* UPDATE IZAPP01, BTBPP05 */
             CALL       PGM(ABMCZ1) PARM(&P@NTYM &PRTG@)

      /* PLATING KANBAN A-PICS REFLECT  */
             CALL       PGM(AAFC10)
      /* Set PLATING KANBAN issue Complete flag  */
             CALL       PGM(AAFR13) PARM('AAFT0111' 'E')

      /* WITHDRAWAL KANBAN A-PICS REFLECT  */
             CALL       PGM(AAHC10)

      /*副資材情報作成 CREATE SECONDARY MATERIALS INFORMATION */
             CALL       PGM(ABMCF0)
 #END:
             DLTDTAARA  DTAARA(&WLIB/AAVACT)

 END:        ENDPGM
