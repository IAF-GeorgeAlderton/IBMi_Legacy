             PGM        PARM(&WSID &HHMM &PHZKB)
             /** ADACJ1 *********************************************/
             /* PROGRAM NAME. : PRODUCTION METHOD FIXED SUB .SYSTEM . (2) */
             /* PROGRAM ID. : ADACJ1. <CLP>                         */
             /* CREATE DATE. : SEP.18,'86.                          */
             /* AUTHOR.              : MR.?.                        */
             /* AUTHOR. N.HYOTO 2000/10/18 ADD TEST MODE            */
             /*                                                     */
             /*  JAN/16/03  USE SWITCH 7,8     H.AMANO              */
             /*  2/14/05  TCH32 ADDED SEND EMAIL                    */
             /* 05/19/08  TCHK1 CHG   ADAR15 QPRINT                 */
             /* 01/28/11  TCHK2 ADD   MAIL RECEIVER                 */
             /* 06/02/11  TCHK3 CHG   MAIL RECEIVER(DLT TANIGUCHI)  */
             /* 08/03/11  TCHK4 RMV   MAIL RECEIVER                 */
             /********************************************* ADACJ1 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&HHMM) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PHZKB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RPY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FIL2) TYPE(*CHAR) LEN(8)
             DCL        VAR(&FIL3) TYPE(*CHAR) LEN(8)
             DCL        VAR(&FIL4) TYPE(*CHAR) LEN(8)
             DCL        VAR(&FIL5) TYPE(*CHAR) LEN(8)
             DCL        VAR(&FIL6) TYPE(*CHAR) LEN(8)
             DCL        VAR(&FIL7) TYPE(*CHAR) LEN(8)
             DCL        VAR(&FIL8) TYPE(*CHAR) LEN(8)
             DCL        VAR(&FIL9) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SW) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PLST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
/* TCH32 */
             DCL        VAR(&EMAIL) TYPE(*CHAR) LEN(20)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
/* TCH32 */
/* TCHK2 */  DCL        VAR(&WWID) TYPE(*CHAR) LEN(10)

/*TCH32      RTVJOBA    USER(&USER)   */
/* TCHK2     RTVJOBA    USER(&USER) NBR(&NBR) */
/* TCHK2 */  RTVJOBA    USER(&USER) NBR(&NBR) JOB(&WWID)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGVAR     VAR(&FIL2) VALUE(%SST(&WSID 1 2) *CAT +
                          'ADAWP2')
             CHGVAR     VAR(&FIL3) VALUE(%SST(&WSID 1 2) *CAT +
                          'ADAWP3')
             CHGVAR     VAR(&FIL4) VALUE(%SST(&WSID 1 2) *CAT +
                          'ADAWP4')
             CHGVAR     VAR(&FIL5) VALUE(%SST(&WSID 1 2) *CAT +
                          'ADAWP5')
             CHGVAR     VAR(&FIL6) VALUE(%SST(&WSID 1 2) *CAT +
                          'ADAWP6')
             CHGVAR     VAR(&FIL7) VALUE(%SST(&WSID 1 2) *CAT +
                          'ADAWP7')
             CHGVAR     VAR(&FIL8) VALUE(%SST(&WSID 1 2) *CAT +
                          'ADAWP8')
             CHGVAR     VAR(&FIL9) VALUE(%SST(&WSID 1 2) *CAT +
                          'ADAWP9')

             /*----------------------------------------------*/
             /*         A-PICSTODAY ACCUMULATION FROM DATA CREATE             */
             /*----------------------------------------------*/
             DLTF       FILE(&FIL2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL2) RCDLEN(200) +
                          TEXT('A-PICSORDERING DATA ADAR11 CREATE') +
                          SIZE(80000 5000) LVLCHK(*NO) AUT(*ALL)

         /* KU#PP11--->AU#PP11 */
             CALL       PGM(ADKR93) PARM(&HHMM)

             OVRPRTF    FILE(ADAPR11) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(62) RPLUNPRT(*YES ' ') +
                          OUTQ(QPRINTS) FORMTYPE(K6H1) +
                          SCHEDULE(*FILEEND) HOLD(*YES) IGCDTA(&PIGCD)
             OVRDBF     FILE(ADAWP11) TOFILE(&FIL2)
             CHGJOB     SWS(0XXXXXXX)
             CALL       PGM(ADAR11) PARM(&PHZKB &USER &HHMM)
             DLTOVR     FILE(ADAWP11)
             DLTOVR     FILE(ADAPR11)

             RTVJOBA    SWS(&SW)
   /*        IF         (%SUBSTRING(&SW 1 1) *EQ '0') GOTO END */

             /*----------------------------------------------*/
             /*         DIVIDED INTO TODAY ORDERING DATA PER DAY */
             /*----------------------------------------------*/
             DLTF       FILE(&FIL3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL3) RCDLEN(200) +
                          TEXT('ORDERING DATA PER DAY DIVSION +
                          FINISHED ADAR12ﾅhﾈb') SIZE(20000 5000) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(ADAWP11) TOFILE(&FIL2)
             OVRDBF     FILE(ADAWP12) TOFILE(&FIL3)
             CALL       PGM(ADAR12) PARM(&HHMM)
             DLTOVR     FILE(ADAWP11)
             DLTOVR     FILE(ADAWP12)

             /*----------------------------------------------*/
             /* THIS TIME PROD ORDER,PROD ORDER USELESSNESS DATA SORT */
             /*----------------------------------------------*/
             DLTF     FILE(&FIL4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL4) RCDLEN(200) TEXT('THIS +
                          TIME ORDERING DATA ADAR13 CREATE') +
                          SIZE(20000 5000) LVLCHK(*NO) AUT(*ALL)

             DLTF     FILE(&FIL5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL5) RCDLEN(200) TEXT('THIS +
                          TIME NON PROD ORDER DATA ADAR13 CREATE') +
                          SIZE(80000 5000) LVLCHK(*NO) AUT(*ALL)

       /*    CHGJOB     SWS(0XXXXXXX)   */
             CHGJOB     SWS(XXXXXX00)
             OVRDBF     FILE(ADAWP12) TOFILE(&FIL3)
             OVRDBF     FILE(ADAWP13) TOFILE(&FIL4)
             OVRDBF     FILE(ADAWP14) TOFILE(&FIL5)
             CALL       PGM(ADAR13) PARM(&HHMM)
             DLTOVR     FILE(ADAWP12)
             DLTOVR     FILE(ADAWP13)
             DLTOVR     FILE(ADAWP14)

      /*                */
             IF         COND(%SWITCH(0XXXXX0X)) THEN(GOTO CMDLBL(END))

             /*----------------------------------------------*/
             /* LAST TIME NON PROD ORDER CLR             */
             /* THIS TIME NON PROD ORDER     WRITING      */
             /*----------------------------------------------*/
 STX1:       CLRPFM     FILE(AD#PP11)
             MONMSG     MSGID(CPF3156 CPF3130) EXEC(DO)
 STX2:       SNDUSRMSG  MSG('( R ) TRYING TO CLRPFM. BUT AD#PP11 IS +
                          USING BY A-PICS KANBAN INVESTIGATION +
                          LIST. PLEASE CONFIRM IT TO PLAN SECTION +
                          THEN INPUT "R" AND ENTER.') VALUES('R') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         (&RPY *EQ 'R') GOTO STX1
             IF         (&RPY *NE 'R') GOTO STX2
             ENDDO

             RTVJOBA    SWS(&SW)
             IF         (%SUBSTRING(&SW 8 1) *EQ '0') GOTO STEP01

 STX3:       CPYF       FROMFILE(&FIL5) TOFILE(AD#PP11) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2909 CPF2950) EXEC(DO)
 STX4:       SNDUSRMSG  MSG('( R ) TRYING TO CPYF. BUT AD#PP11 IS +
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
             CALL       PGM(ADAR14) PARM(&PLST)
             DLTOVR     FILE(INPUT)
             DLTOVR     FILE(OUTPUT)
             DLTOVR     FILE(OUTPUT1)

             IF         (&PLST *EQ '*') DO

             DLTF       FILE(&FIL9)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL9) RCDLEN(100) SIZE(20000 +
                          5000) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/&FIL8)) OUTFILE(&WLIB/&FIL9) +
                          SRCFILE(FMTSRC) SRCMBR(ADAS15) OPTION(*NOPRT)

             /*----------------------------------------------*/
             /*     ﾃ]fbmﾌbmﾞｰj ﾆﾞｬkｬcﾇcbﾆﾞｭcmﾞｰj ﾉ ﾓbﾈg     */
             /*         1996.SEP.11.      S.OHTAKE           */
             /*----------------------------------------------*/

   /*    STXA:   CPYF       FROMFILE(&FIL9) TOFILE(ADAPP41) +  */
   /*                MBROPT(*ADD)     FMTOPT(*NOCHK)           */

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(LANPRT50) FORMTYPE(K6H1) HOLD(*YES)
             OVRDBF     FILE(ADAWP15) TOFILE(&FIL9)
             CALL       PGM(ADAR15) PARM(&HHMM)
   /* TCH32  */
/* TCHK2     CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST) */
/* TCHK2 */  CLRPFM     FILE(HWFILE1/PRT132C)
/* TCHK2 */  CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132C) +
                          JOB(&NBR/&USER/&WWID) SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(SKIPT))

/* TCHK2     OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132) */
/* TCHK2 */  OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132C)
             CALL       PGM(AB#RW0)
             DLTOVR     FILE(PRT132)

             CALL       PGM(ADAR16) PARM(&EMAIL)

/* TCHK2     IF         (&EMAIL *NE '                    ') DO */
/* TCHK2       SNDDST     TYPE(*FILE) TOINTNET((&EMAIL)) DSTD('Order +
                            above setting number') MSG('We received +
                            the order which has above setting number. +
                            check the attached list.') +
                            DOCFILE(HWFILE1/PRT132) DOCTYPE(*FFT) +
                            SNDFMT(*NOTE) DOCD('Order above setting +
                            number') */
/* TCHK2       MONMSG     MSGID(CPF0000) */
/* TCHK1       RLSSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST) */
/* TCHK2       MONMSG     MSGID(CPF0000) */
/* TCHK2     ENDDO */

/* TCHK2 */
/* TCHK4     SNDDST     TYPE(*FILE) TOINTNET(                      +
                          (Atsuo.Mamiya@iafi.com)                  +
                          (Katsunori.Tanebe@iafi.com *CC)          +
                                            )                      +
                          DSTD('Order above setting number')       +
                          MSG('We received the order which has abo +
                          ve setting number. +
                          check the attached list.') +
                          DOCFILE(HWFILE1/PRT132C) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('Order above setting +
                          number')                                   */
/* TCHK4     MONMSG     MSGID(CPF0000) */
/* TCHK2 */

     SKIPT:
   /* TCH32  */
             DLTOVR     FILE(ADAWP15)
             DLTOVR     FILE(QPRINT)

             SNDPGMMSG  MSG('THE PRESENCE OF THE ABNORMAL LIST ON +
                          THE NUMBER OF THE RECEIVED ORDER IN THE +
                          ARRANGED DATA HAS BEEN AKNOWLEDGED. +
                          PLEASE, VERIFY THE CONTENTS.') +
                          TOMSGQ(QSYSOPR)

             ENDDO

             CALL       PGM(AGIC21) PARM(&HHMM)

      /*上限カット　直接入力分の出力 */
             CALL       PGM(ADKC10) PARM(&HHMM)
      /*上限カット*/
             CALL       PGM(ADKC11) PARM(&HHMM &FIL7)

             OVRDBF     FILE(INPUT) TOFILE(&FIL7)
      /***   CALL       PGM(AGAR10) PARM(&HHMM)    ***/
             DLTOVR     FILE(INPUT)

             CALL       PGM(AGIC22) PARM(&HHMM)

 END:        ENDPGM
