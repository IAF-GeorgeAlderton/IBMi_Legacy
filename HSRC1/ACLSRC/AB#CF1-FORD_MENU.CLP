             PGM
/** AB#CF1 ***********************************************************/
/*  EDI FORD MENU                                                    */
/*  (&SELET=SELECTED OPT#)                                           */
/*  TCHK8    2015.03.16 CHG RMV I0054&I0016  ADD I0088               */
/*  JW1      2015.12.14 ADD OPT64 (SHIPTO &CONTAINER MAINT.)         */
/*  T.SAKAKI 2016.01.09 ADD OPT90 CUM RESET     %0001                */
/*  LEC      2016.01.26 ADD OPT82 ASN RECEIVED INQUIRY               */
/*  JW2      2017.11.01 ADD OPT65 MAINTENANCE PO CODE                */
/*  JW3      2017.11.06 ADD OPT83 FORD ASN J-COMM DATA               */
/*  JW4      2019.01.23 ADD ULTR07 TO DETECT WHO RUN QUERY           */
/*  JW5      2020.11.16 ADD OPT#84 ASN INQ                           */
/*  JW6      2022.01.31 ADD OPT#85 FORD INQ MENU                     */
/*  "        2022.06.23 ADD OPT#53 FORD INQ MENU                     */
/*  JW7      2022.11.10 ADD EXCLUSION PROGRAM TO #22 & #23           */
/*  LEC      2022.12.20 ADD I0223 TO ALLOW FORD CUM RESET #90        */
/*  LEC      2025.12.12 CHG I0088 TO I0249 FORD CUM RESET #90        */
/*********************************************************************/
             DCLF       FILE(AB#PWF1)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JER)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&YEAR) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NONY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOHZ) TYPE(*DEC)  LEN(8 0)
             DCL        VAR(&NOBN) TYPE(*DEC)  LEN(2 0)
             DCL        VAR(&REHZ) TYPE(*DEC)  LEN(8 0)
             DCL        VAR(&FLG ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN2) TYPE(*CHAR) LEN(1)

/* TCHK7 */  OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
/* TCHK7 */  OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
/* TCHK7 */  OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             RTVJOBA    JOB(&WSID) USER(&USID) DATE(&DATE)
             CHGVAR     VAR(&YEAR) VALUE('20' *CAT %SST(&DATE 1 2))
/* TCHK8 */  CHGVAR     VAR(&IN88)   VALUE('1')

             IF         COND(&USID *EQ 'I0249' *OR &USID *EQ 'I0051' +
                          *OR &USID *EQ 'QPGMR') THEN(CHGVAR +
                          VAR(&IN88) VALUE('0')) /* TCHK8 */

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
 STP1:
             CALL       PGM(AB#RFO) PARM(&JER)
             IF         COND(&JER *EQ '1') THEN(DO)
             CALL AB#RFP
             ENDDO

             IF         COND(&JER *EQ '3') THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
     /**JW5  CHGVAR     VAR(&IN63) VALUE('1') **/
             CHGVAR     VAR(&MSG) VALUE('ASK YOUR SUPERVISOR TO +
                          RESET CUM. FROM AUGUST/01 THIS YEAR.')
             ENDDO

             CALL       PGM(AB#R0Y) PARM(&D@DAT &D@TIM)

 STP2:
             SNDRCVF    DEV(&WSID) RCDFMT(AB#PWF01)

             CHGVAR     VAR(&IN99) VALUE('0')
     /**JW5  CHGVAR     VAR(&IN63) VALUE('0') **/
             CHGVAR     VAR(&MSG) VALUE('                            ')

             IF         (&IN01 *EQ '1') GOTO END

             IF         (&SELET *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('SELECT MENU NUMBER')
             GOTO       STP1
             ENDDO

             IF         (&IN05 *EQ '0') GOTO STP1

 /* RE-PRINT DATA LIST */
             IF         COND(&SELET *EQ '2') THEN(DO)
             CALL       PGM(AB#RF2)
             GOTO       STP9
             ENDDO

 /* FRS EXPORT ORDER PROCESSING */
             IF         (&SELET *EQ '4') THEN(DO)
             CALL       PGM(AB#C2G11)
             GOTO       STP9
             ENDDO

 /* PRINT WEEKLY ORDER LIST */
             IF         (&SELET *EQ '5') THEN(DO)
             CALL       PGM(AB#CFQ)
             GOTO       STP9
             ENDDO

 /* CREATE FOR FRS DATA */
             IF         (&SELET *EQ '6') THEN(DO)
             CALL       PGM(AB#CF7) PARM(&SELET '      ** CREATE FRS +
                          ORDER **       ')
             GOTO       STP9
             ENDDO

 /* RE-CREATE FOR FRS DATA */
             IF         (&SELET *EQ '7') THEN(DO)
             CALL       PGM(AB#CF7) PARM(&SELET '*RE-CREATE FRS +
                          ORDER(ADD TO LIST)*') /* ' */
             GOTO       STP9
             ENDDO

 /* PACKING LIST */
             IF         (&SELET *EQ '10') THEN(DO)
             CALL       PGM(AB#CF4)
             GOTO       STP9
             ENDDO

 /* PACKING LIST FREEZE */
             IF         (&SELET *EQ '11') THEN(DO)
             CALL       PGM(AB#CFA)
             GOTO       STP9
             ENDDO
 /* PACKING LIST FOR SUPERVISOR)  */
             IF         COND(&SELET *EQ '12' *AND &IN88 *EQ '0') +
                          THEN(DO)
             CALL       PGM(AB#CFB)
             GOTO       STP9
             ENDDO
 /* PACKING LIST REPRINT          */
             IF         COND(&SELET *EQ '13') THEN(DO)
             CALL       PGM(AB#RG1)
             GOTO       STP9
             ENDDO
 /* CONTAINER INQ. BY SHIP DATA */
             IF         COND(&SELET *EQ '14') THEN(DO)
             CALL       PGM(AB#C9D)
             GOTO       STP9
             ENDDO

 /* CONTAINER INQ. BY SHIP DATA WITH INVENTORY */
             IF         COND(&SELET *EQ '15') THEN(DO)
             CALL       PGM(AB#C9E)
             GOTO       STP9
             ENDDO

 /* LABEL DATA (2D) */
             IF         (&SELET *EQ '22') THEN(DO)

/* CHECK OTHER USER IS USING  JW7 ==================================*/
             CALL       PGM(CHKC45) PARM('AB#CF1' 'AB#RF1' 'Y' 'CHK' &RTN2)
             IF         COND(&RTN2 *NE ' ') THEN(GOTO STP9 )
/* =================================================================*/

             CLRPFM     FILE(ABF7P01)
             CLRPFM     FILE(ABF7P02)
             CLRPFM     FILE(ABF7P03)
             CALL       PGM(AB#RF1)
             CALL       PGM(AB#RYY)

             CPYF       FROMFILE(ABF7P01) TOFILE(SAMELIB/ABF7P01) +
                          MBROPT(*ADD) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)

             CPYF       FROMFILE(ABF7P02) TOFILE(SAMELIB/ABF7P02) +
                          MBROPT(*ADD) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)

             CPYF       FROMFILE(ABF7P03) TOFILE(SAMELIB/ABF7P03) +
                          MBROPT(*ADD) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)

 /*JW7*/     CALL       PGM(CHKC45) PARM('AB#CF1' 'AB#RF1' 'N' '' '')

             GOTO       STP9
             ENDDO

 /* RE-PRINT LABEL(2D) */

             IF         (&SELET *EQ '23') THEN(DO)

/* CHECK OTHER USER IS USING  JW7 ==================================*/
             CALL       PGM(CHKC45) PARM('AB#CF1' 'AB#RF4' 'Y' 'CHK' &RTN2)
             IF         COND(&RTN2 *NE ' ') THEN(GOTO STP9 )
/* =================================================================*/

             CLRPFM     FILE(ABF7P01)
             CLRPFM     FILE(ABF7P02)
             CLRPFM     FILE(ABF7P03)
             CALL       PGM(AB#RF4)
             CALL       PGM(AB#RYY)

 /*JW7*/     CALL       PGM(CHKC45) PARM('AB#CF1' 'AB#RF4' 'N' '' '')

             GOTO       STP9
             ENDDO

 /* LABEL MAINTENANCE  */
             IF         (&SELET *EQ '24') THEN(DO)
             CALL       PGM(AB#RAQF)
             GOTO       STP9
             ENDDO

 /* BILL OF LADING */
             IF         (&SELET *EQ '30') THEN(DO)
             CALL       PGM(AB#CFI)
             GOTO       STP9
             ENDDO

 /* MIXED LOAD LIST */
             IF         (&SELET *EQ '31') THEN(DO)
             CALL       PGM(AB#CF81)
             GOTO       STP9
             ENDDO

 /* CUSTOM SHEET */
             IF         (&SELET *EQ '40') THEN(DO)
             CALL       PGM(AB#CF2)
             GOTO       STP9
             ENDDO
 /* LABEL SCAN CHECK */
             IF         (&SELET *EQ '45') THEN(DO)
             CALL       PGM(AB#RA6) PARM(&NONY &NKOJ &NUKE &NOHZ +
                          &NOBN &REHZ &FLG)
             GOTO       STP9
             ENDDO
 /* LINE FEED SERACH */
             IF         (&SELET *EQ '46') THEN(DO)
             CALL       PGM(AB#RG2)
             GOTO       STP9
             ENDDO
 /* SHIP HISTORY & FORECAST */
             IF         (&SELET *EQ '47') THEN(DO)
             CALL       PGM(ABBC57)
             GOTO       STP9
             ENDDO
 /* DISUSE PARTS INF   T */
             IF         (&SELET *EQ '48') THEN(DO)
             CALL       PGM(ABAC3L)
             GOTO       STP9
             ENDDO

 /* RETURNABLE SHIPMENT HISTORY(# OF BOX) */
             IF         (&SELET *EQ '49') THEN(DO)
             CALL       PGM(ABBC58)
             GOTO       STP9
             ENDDO

 /* CREATE ASN DATA GENTRAN */
             IF         (&SELET *EQ '50') THEN(DO)
             CALL       PGM(AB#C0K)
             GOTO       STP9
             ENDDO

 /* FORECAST VS. SETTIGN QTY */
             IF         (&SELET *EQ '51') THEN(DO)
             CALL       PGM(ABBC56)
             GOTO       STP9
             ENDDO

 /* ASN PATTERN FILE MAINTENANCE */
             IF         (&SELET *EQ '52') THEN(DO)
             CALL       PGM(ABFR05)
             GOTO       STP9
             ENDDO

 /* JW6 CANCEL ASN               */
             IF         (&SELET *EQ '53') THEN(DO)
             CALL       PGM(JCMC30)
             GOTO       STP9
             ENDDO

 /* MAINTENANCE ADDRESS MASTER */
             IF         (&SELET *EQ '60') THEN(DO)
             CALL       PGM(AB#RFT) PARM(&USID)
             GOTO       STP9
             ENDDO

 /* MAINTENANCE ROUTE MASTER */
             IF         (&SELET *EQ '61') THEN(DO)
             CALL       PGM(ABFR01)
             GOTO       STP9
             ENDDO
 /* MAINTENANCE BIN/ ROUTE MASTER */
             IF         (&SELET *EQ '62') THEN(DO)
             CALL       PGM(ABFR04)
             GOTO       STP9
             ENDDO

 /* MAINTENANCE CUM. MASTER */
             IF         (&SELET *EQ '63') THEN(DO)
             CALL       PGM(ABFR06)
             GOTO       STP9
             ENDDO

 /* MAINTENANCE SHIP TO & CONTAINER (JW1) */
             IF         (&SELET *EQ '64') THEN(DO)
             CALL       PGM(AB#RY1) PARM(&USID)
             GOTO       STP9
             ENDDO

 /* MAINTENANCE PO CODE             (JW2) */
             IF         (&SELET *EQ '65') THEN(DO)
             CALL       PGM(FBCC41)
             GOTO       STP9
             ENDDO

 /* CUM. LIST BY PLANT DOCK */
             IF         (&SELET *EQ '70') THEN(DO)
             RUNQRY     QRY(QFORD4)
 /*JW4    ***CALL       PGM(UTLR07) PARM('CUM LIST #70 QFORD4/FORD MENU') ***/
             CALL       PGM(UTLR07D) PARM('QFORD4' 'CUM LIST #70 +
                          QFORD4/FORD MENU') /*JW4*/
             GOTO       STP9
             ENDDO

 /* PRINT FUTURE FORD ORDER INFORMATION */
             IF         (&SELET *EQ '71') THEN(DO)
             CALL       PGM(AB#CFS)
             GOTO       STP9
             ENDDO

 /* FORD SHIPPING STATUS INQ                         */
             IF         (&SELET *EQ '80') THEN(DO)
     /****** CALL       PGM(AB#C9M ) ******/
             CALL       PGM(AB#C9M1)
             GOTO       STP9
             ENDDO

 /* FORD FABRICATION & RAW MATERIAL INQUIRY */
             IF         (&SELET *EQ '81') THEN(DO)
             CALL       PGM(AB#RFU)
             GOTO       STP9
             ENDDO

 /* FORD ASN RECEIVED FOR RETURNABLE CONTAINERS INQUIRY */
    /**JW6   IF         (&SELET *EQ '82') THEN(DO)     **/
    /**      CALL       PGM(ABFR42)                    **/
    /**      GOTO       STP9                           **/
    /**      ENDDO                                     **/

 /* FORD ASN J-COMM DATA  BY JW3                        */
             IF         (&SELET *EQ '83') THEN(DO)
             CALL       PGM(JCMC14)
             GOTO       STP9
             ENDDO

 /* FORD ASN INQUIRY      BY JW5                        */
             IF         (&SELET *EQ '84') THEN(DO)
             CALL       PGM(JCMR20B)
             GOTO       STP9
             ENDDO

 /* FORD INQUIRY MENU BY JW6                            */
             IF         (&SELET *EQ '85') THEN(DO)
             CALL       PGM(AB#CF1A)
             GOTO       STP9
             ENDDO

 /* FORD CUM RESET %0001 */
             IF         COND(&SELET *EQ '90' *AND &IN88 *EQ '0') +
                          THEN(DO)
             CALL       PGM(AB#CFX)
             GOTO       STP9
             ENDDO

 /* RESET CUM QTY             */
             IF         COND(&SELET *EQ 'AG' *AND &IN88 *EQ '0') +
                          THEN(DO)
   /*  LEC   CALL       PGM(AB#CFY)                           */
             CHGVAR     VAR(&SELET) VALUE('  ')
             GOTO       STP1
             ENDDO

             IF         COND(&SELET *EQ 'AG' *AND &IN88 *EQ '1') +
                          THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('YOU ARE NOT SUPPOSED TO DO +
                          THIS JOB.')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&SELET) VALUE('  ')
             GOTO       STP2
             ENDDO
 STP9:
             CHGVAR     VAR(&SELET) VALUE('  ')
             GOTO       STP2
 END:
             ENDPGM
