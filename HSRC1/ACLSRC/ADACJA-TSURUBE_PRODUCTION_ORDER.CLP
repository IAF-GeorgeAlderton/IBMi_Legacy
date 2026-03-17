             PGM        PARM(&WSID &HHMM &PHZKB +
                                         &PB0111 &PI0111 &DAY)
             /** ADACJA *********************************************/
             /* つるべ生産指示                                    */
             /* 2020.07.14                                          */
             /********************************************* ADACJA **/
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&HHMM)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&PHZKB)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PB0111) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PI0111) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DAY)    TYPE(*CHAR) LEN(8)

             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&WWID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)

             DCL        VAR(&FIL2)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&FIL3)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&FIL4)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&FIL5)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&FIL6)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&FIL7)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&FIL8)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&FIL9)   TYPE(*CHAR) LEN(8)

             DCL        VAR(&SW)     TYPE(*CHAR) LEN(8)
             DCL        VAR(&RPY)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PLST)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&EMAIL)  TYPE(*CHAR) LEN(20)
             DCL        VAR(&PRTER)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PMSG)   TYPE(*CHAR) LEN(1)

             RTVJOBA    USER(&USER) NBR(&NBR) JOB(&WWID)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGVAR     VAR(&FIL2) VALUE(%SST(&WSID 1 2) *CAT +
                          'ADAWPA')
             CHGVAR     VAR(&FIL3) VALUE(%SST(&WSID 1 2) *CAT +
                          'ADAWPB')
             CHGVAR     VAR(&FIL4) VALUE(%SST(&WSID 1 2) *CAT +
                          'ADAWPC')
             CHGVAR     VAR(&FIL5) VALUE(%SST(&WSID 1 2) *CAT +
                          'ADAWPE')
             CHGVAR     VAR(&FIL6) VALUE(%SST(&WSID 1 2) *CAT +
                          'ADAWPE')
             CHGVAR     VAR(&FIL7) VALUE(%SST(&WSID 1 2) *CAT +
                          'ADAWPF')
             CHGVAR     VAR(&FIL8) VALUE(%SST(&WSID 1 2) *CAT +
                          'ADAWPG')
             CHGVAR     VAR(&FIL9) VALUE(%SST(&WSID 1 2) *CAT +
                          'ADAWPH')

             /*----------------------------------------------*/
             /*  A-PICSTODAY ACCUMULATION FROM DATA CREATE   */
             /*----------------------------------------------*/
             DLTF       FILE(&FIL2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL2) RCDLEN(200) +
                          TEXT('A-PICSORDERING DATA ADAR1A CREATE') +
                          SIZE(80000 5000) LVLCHK(*NO) AUT(*ALL)

   /* KU#PP11--->AU#PP91 */
             CALL       PGM(ADKR9A) PARM(&HHMM)


             OVRPRTF    FILE(ADAPR11) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(62) RPLUNPRT(*YES ' ') +
                          OUTQ(QPRINTS) FORMTYPE(K6H1) +
                          SCHEDULE(*FILEEND) HOLD(*YES) IGCDTA(&PIGCD)

             OVRDBF     FILE(ADAWP1A) TOFILE(&FIL2)
             CHGJOB     SWS(0XXXXXXX)
   /* AU#PP91--->ADAWP1A */
             CALL       PGM(ADAR1A) PARM(&PHZKB &USER &HHMM)

             DLTOVR     FILE(ADAWP1A)
             DLTOVR     FILE(ADAPR11)

             /*----------------------------------------------*/
             /*     DIVIDED INTO TODAY ORDERING DATA PER DAY */
             /*----------------------------------------------*/
             DLTF       FILE(&FIL3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL3) RCDLEN(200) +
                          TEXT('ORDERING DATA PER DAY DIVSION +
                          FINISHED ADAR1Bﾅhﾈb') SIZE(20000 5000) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(ADAWP1A) TOFILE(&FIL2)
             OVRDBF     FILE(ADAWP1B) TOFILE(&FIL3)
   /* ADAWP1A--->ADAWP1B */
             CALL       PGM(ADAR1B) PARM(&HHMM)
             DLTOVR     FILE(ADAWP1A)
             DLTOVR     FILE(ADAWP1B)

             /*----------------------------------------------*/
             /* THIS TIME PROD ORDER,PROD ORDER USELESSNESS DATA SORT */
             /*----------------------------------------------*/
             DLTF     FILE(&FIL4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL4) RCDLEN(200) TEXT('THIS +
                          TIME ORDERING DATA ADAR1C CREATE') +
                          SIZE(20000 5000) LVLCHK(*NO) AUT(*ALL)

             DLTF     FILE(&FIL5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL5) RCDLEN(200) TEXT('THIS +
                          TIME NON PROD ORDER DATA ADAR1C CREATE') +
                          SIZE(80000 5000) LVLCHK(*NO) AUT(*ALL)

             CHGJOB     SWS(XXXXXX00)
             OVRDBF     FILE(ADAWP1B) TOFILE(&FIL3)
             OVRDBF     FILE(ADAWP1C) TOFILE(&FIL4)
             OVRDBF     FILE(ADAWP1D) TOFILE(&FIL5)
   /* ADAWP1B--->ADAWP1C､ADAWP1D ADKPP06 */
             CALL       PGM(ADAR1C) PARM(&HHMM)
             DLTOVR     FILE(ADAWP1B)
             DLTOVR     FILE(ADAWP1C)
             DLTOVR     FILE(ADAWP1D)

      /* U7 = *OFF      */
             IF         COND(%SWITCH(0XXXXX0X)) THEN(GOTO @SKIP)

             /*----------------------------------------------*/
             /* LAST TIME NON PROD ORDER CLR             */
             /* THIS TIME NON PROD ORDER     WRITING      */
             /*----------------------------------------------*/
 STX1:       CLRPFM     FILE(AD#PP15)
             MONMSG     MSGID(CPF3156 CPF3130) EXEC(DO)
 STX2:       SNDUSRMSG  MSG('( R ) TRYING TO CLRPFM. BUT AD#PP15 IS +
                          USING BY A-PICS KANBAN INVESTIGATION +
                          LIST. PLEASE CONFIRM IT TO PLAN SECTION +
                          THEN INPUT "R" AND ENTER.') VALUES('R') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         (&RPY *EQ 'R') GOTO STX1
             IF         (&RPY *NE 'R') GOTO STX2
             ENDDO

      /* U8 = *OFF      */
             RTVJOBA    SWS(&SW)
             IF         (%SUBSTRING(&SW 8 1) *EQ '0') GOTO STEP01

   /* ADAWP1D--->AD#PP15 */
 STX3:       CPYF       FROMFILE(&FIL5) TOFILE(AD#PP15) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2909 CPF2950) EXEC(DO)
 STX4:       SNDUSRMSG  MSG('( R ) TRYING TO CPYF. BUT AD#PP15 IS +
                          USING BY A-PICS KANBAN INVESTIGATION +
                          LIST. PLEASE CONFIRM IT TO PLAN SECTION +
                          THEN INPUT "R" AND ENTER.') VALUES('R') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         (&RPY *EQ 'R') GOTO STX3
             IF         (&RPY *NE 'R') GOTO STX4
             ENDDO

             /*----------------------------------------------*/
             /*    THIS TIME PROD ORDER DATA TOTALIZED BY PART NO. */
             /*----------------------------------------------*/
 STEP01:     DLTF       FILE(&FIL6)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL6) RCDLEN(200) TEXT('THIS +
                          TIME ORDERING DATA ADAS14 CREATE') +
                          SIZE(20000 5000) LVLCHK(*NO) AUT(*ALL)


             FMTDTA     INFILE((&WLIB/&FIL4)) OUTFILE(&WLIB/&FIL6) +
                          SRCFILE(FMTSRC) SRCMBR(ADAS14) OPTION(*NOPRT)

             DLTF       FILE(&FIL7)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL7) RCDLEN(200) TEXT('THIS +
                          TIME ORDERING DATA ADAR14 CREATE') +
                          SIZE(20000 5000) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL8)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL8) RCDLEN(100) SIZE(20000 +
                          5000) LVLCHK(*NO) AUT(*ALL)

             CHGVAR     VAR(&PLST) VALUE(' ')

             OVRDBF     FILE(INPUT) TOFILE(&FIL6)
             OVRDBF     FILE(OUTPUT) TOFILE(&FIL7)
             OVRDBF     FILE(OUTPUT1) TOFILE(&FIL8)
   /* ADAWP1C--->OUTPUT､OUTOUT1(ERROR) */
             CALL       PGM(ADAR1D) PARM(&PLST)
             DLTOVR     FILE(INPUT)
             DLTOVR     FILE(OUTPUT)
             DLTOVR     FILE(OUTPUT1)


   /*  ORDER RECEIPT QUANTITY ABNOMAL LIST <<START-------->> */
             IF         (&PLST *EQ '*') DO

             DLTF       FILE(&FIL9)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL9) RCDLEN(100) SIZE(20000 +
                          5000) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/&FIL8)) OUTFILE(&WLIB/&FIL9) +
                          SRCFILE(FMTSRC) SRCMBR(ADAS15) OPTION(*NOPRT)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(LANPRT50) FORMTYPE(K6H1) HOLD(*YES)
             OVRDBF     FILE(ADAWP15) TOFILE(&FIL9)
   /* ADAWP15--->QPRINT */
             CALL       PGM(ADAR15) PARM(&HHMM)

             CLRPFM     FILE(HWFILE1/PRT132C)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132C) +
                          JOB(&NBR/&USER/&WWID) SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(SKIPT))

             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132C)
             CALL       PGM(AB#RW0)
             DLTOVR     FILE(PRT132)

   /* RETRIEV EMAIL ADDRESS  */
             CALL       PGM(ADAR16) PARM(&EMAIL)


     SKIPT:
             DLTOVR     FILE(ADAWP15)
             DLTOVR     FILE(QPRINT)

             SNDPGMMSG  MSG('THE PRESENCE OF THE ABNORMAL LIST ON +
                          THE NUMBER OF THE RECEIVED ORDER IN THE +
                          ARRANGED DATA HAS BEEN AKNOWLEDGED. +
                          PLEASE, VERIFY THE CONTENTS.') +
                          TOMSGQ(QSYSOPR)

             ENDDO
   /*  ORDER RECEIPT QUANTITY ABNOMAL LIST <<----------END>> */


   /*  AGIWP08の作成??????????????????????????*/
   /*        CALL       PGM(AGIC21) PARM(&HHMM) */


      /*上限カット　直接入力分の出力  AGAPP41 --> ADKPP15 */
             CALL       PGM(ADKC20) PARM(&HHMM)

      /*上限カット*/
             CALL       PGM(ADKC21) PARM(&HHMM &FIL7)


   /*********************************************/
   /*????? / CALL       PGM(AGIC22) PARM(&HHMM) */


 @SKIP:    /*--------------------------------------------------------*/
           /*--------------------------------------------------------*/


             CHKOBJ     OBJ(AFAWP42) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&WLIB/AFAWP42) RCDLEN(250) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))

             /*------------------------------------*/
             /*   LEVELLED PRODUCTION DECISION ORDERING ACCUMULATION FILE   */
             /*------------------------------------*/
 @03XX:      CLRPFM     FILE(AFAWP42)

   /* AGAPP41--->AFAWP42 */
             CALL       PGM(AFAR42) PARM(&PB0111 &PI0111 &DAY)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR AT PGM(AFAR42) +
                          < RETRY-R +
                          CANCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         COND((&RPY *EQ 'R') *OR (&RPY *EQ 'r')) +
                          THEN(GOTO CMDLBL(@03XX))
             RETURN
             ENDDO


 $03XX:      CHGVAR     VAR(&PRTER) VALUE(' ')
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)


          /*臨時かんばん分を出力する    */
   /* ADKPP35--->ADKPP16 */
   /*        --->AFAWP42 */
             CALL       PGM(ADKR28) PARM(&DAY &PB0111 &PI0111 &PRTER)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR AT PGM(AFAR32) +
                          < RETRY-R +
                          CANCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         COND((&RPY *EQ 'R') *OR (&RPY *EQ 'r')) +
                          THEN(GOTO CMDLBL($03XX))
             RETURN
             ENDDO

             IF         (&PRTER *NE ' ') DO
             SNDPGMMSG  +
                          MSG('PLEASE HAND A-PICS TEMPORARY KANBAN DATA +
                          ERROR LIST TO BOSS AT PRODUCTION ENGINEERING +
                          SECTION.') TOMSGQ(QSYSOPR)
             ENDDO

             DLTOVR     FILE(QPRINT)


             CHKOBJ     OBJ(AFAWP43) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&WLIB/AFAWP43) RCDLEN(250) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))
             CLRPFM     FILE(AFAWP43)

             FMTDTA     INFILE((&WLIB/AFAWP42)) +
                          OUTFILE(&WLIB/AFAWP43) SRCFILE(FMTSRC) +
                          SRCMBR(AFAS12) OPTION(*NOPRT)

             CHKOBJ     OBJ(AFAWP44) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&WLIB/AFAWP44) RCDLEN(250) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))

@05XX:       CLRPFM     FILE(AFAWP44)

             CHGVAR     VAR(&PMSG) VALUE(' ')
             OVRPRTF    FILE(ATAPR96) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
   /* AFAWP43--->AFAWP44 */
             CALL       PGM(AFAR43) PARM(&PMSG &USER)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR AT PGM(AFAR43) +
                          < RETRY-R +
                          CANCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         COND((&RPY *EQ 'R') *OR (&RPY *EQ 'r')) +
                          THEN(GOTO CMDLBL(@05XX))
             RETURN
             ENDDO


             IF         (&PMSG *EQ '*') DO
             SNDPGMMSG  +
                          MSG('IT IS LOOPED DELIVERY DATE CALCULATION +
                          FOR PRODUCT INSTRUCTION DATA. PLEASE HAND +
                          DELIVERY DATE CALCULATION IMPOSSIBLE DETAILS +
                          LIST TO BOSS AT PRODUCTION ENGINEERING SECTION.') +
                          TOMSGQ(QSYSOPR)
             ENDDO
             DLTOVR     FILE(ATAPR96)

             /*-------------------------------------------*/
             /*  AFAWP44を作成して終了                  */
             /* 以後の処理はAFACJ1のAGJR13で処理する*/
             /*-------------------------------------------*/


 END:        ENDPGM
