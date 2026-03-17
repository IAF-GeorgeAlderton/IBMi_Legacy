  PGM
/** AN#CF1 *************************************************/
/*  ANDROID EDI MENU                                       */
/*                                                         */
/* TCHK1 07/10/06 CREATE(COPY FROM AB#CF1)                 */
/***********************************************************/
             DCLF       FILE(HOBJ1/AN#PWF1)
             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USID)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&JER)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATE)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&YEAR)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&NONY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOHZ) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&NOBN) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&REHZ) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&FLG) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USID) DATE(&DATE)
             CHGVAR     VAR(&YEAR) VALUE('20' *CAT %SST(&DATE 1 2))
             IF         COND(&USID *NE 'I0016') THEN(CHGVAR +
                          VAR(&IN88) VALUE('1'))

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 STP1:

             CALL       PGM(AN#RFO) PARM(&JER)
             IF         COND(&JER *EQ '1') THEN(DO)
             CALL       AB#RFP
             ENDDO

             IF         COND(&JER *EQ '3') THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN63) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('ASK YOUR SUPERVISOR TO +
                          RESET CUM. FROM AUGUST/01 THIS YEAR.')
             ENDDO

             CALL       PGM(AN#R0Y) PARM(&D@DAT &D@TIM)

 STP2:

             SNDRCVF    DEV(&WSID) RCDFMT(AN#PWF01)

             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&IN63) VALUE('0')
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
             CALL       PGM(AN#RF2)
             ENDDO

 /* FRS EXPORT ORDER PROCESSING */
    /*       IF         (&SELET *EQ '4') THEN(DO) */
    /*       CALL       PGM(AB#C2G11)             */
    /*       ENDDO                                */

 /* PRINT WEEKLY ORDER LIST */
/*           IF         (&SELET *EQ '5') THEN(DO) */
/*           CALL       PGM(AB#CFQ)               */
/*           ENDDO                                */

 /* CREATE FOR FRS DATA */
             IF         (&SELET *EQ '6') THEN(DO)
           CALL PGM(TOBJ1/AN#CF7TST) PARM(&SELET '      ** CREATE FRS +
                          ORDER **       ')
             ENDDO

 /* RE-CREATE FOR FRS DATA */
             IF         (&SELET *EQ '7') THEN(DO)
           CALL PGM(TOBJ1/AN#CF7TST) PARM(&SELET '*RE-CREATE FRS +
                          ORDER(ADD TO LIST)*') /* ' */
             ENDDO

 /* CONTAINER INQ. BY SHIP DATA */
/*           IF         (&SELET *EQ '8') THEN(DO) */
/*           CALL       PGM(AB#R92)               */
/*           ENDDO                                */

 /* PACKING SLIP */
             IF         (&SELET *EQ '10') THEN(DO)
             CALL       PGM(TOBJ1/AN#CF4TST)
             ENDDO

 /* PACKING SLIP FREEZE */
             IF         (&SELET *EQ '11') THEN(DO)
             CALL       PGM(AN#CFA)
             ENDDO

 /* PACKING SLIP FOR SUPERVISOR)  */
             IF         COND(&SELET *EQ '12' *AND &IN88 *EQ '0') +
                          THEN(DO)
             CALL       PGM(AN#CFB)
             ENDDO

 /* PACKING SLIP REPRINT          */
             IF         COND(&SELET *EQ '13') THEN(DO)
             CALL       PGM(AN#RG1)
             ENDDO

 /* CONTAINER INQ. BY SHIP DATA */
             IF         COND(&SELET *EQ '14') THEN(DO)
             CALL       PGM(AB#C9D)
             ENDDO

 /* LABEL DATA (2D) */
             IF         (&SELET *EQ '22') THEN(DO)
             CLRPFM     FILE(ABR7P01)
             CLRPFM     FILE(ABR7P02)
             CLRPFM     FILE(ABR7P03)
             OVRDBF     FILE(AB#PL14) TOFILE(TFILE1/AB#PL14)
             OVRDBF     FILE(AB#NP30) TOFILE(TFILE1/AB#NP30)
             OVRDBF     FILE(AB#PP70) TOFILE(TFILE1/AB#PP70)
             OVRDBF     FILE(AB#PL76) TOFILE(TFILE1/AB#PL76)
             CALL       PGM(AN#RF1)
             DLTOVR     FILE(*ALL)
             ENDDO

 /* RE-PRINT LABEL(2D) */
             IF         (&SELET *EQ '23') THEN(DO)
             CLRPFM     FILE(ABR7P01)
             CLRPFM     FILE(ABR7P02)
             CLRPFM     FILE(ABR7P03)
             OVRDBF     FILE(AB#PL14) TOFILE(TFILE1/AB#PL14)
             OVRDBF     FILE(AB#NP30) TOFILE(TFILE1/AB#NP30)
             OVRDBF     FILE(AB#PP70) TOFILE(TFILE1/AB#PP70)
             OVRDBF     FILE(AB#PL76) TOFILE(TFILE1/AB#PL76)
             CALL       PGM(AN#RF4)
             DLTOVR     FILE(*ALL)
             ENDDO

 /* BILL OF LADING */
             IF         (&SELET *EQ '30') THEN(DO)
             CALL       PGM(AN#CFI)
             ENDDO

 /* MIXED LOAD LIST */
/*           IF         (&SELET *EQ '31') THEN(DO) */
/*           CALL       PGM(AN#CF81)               */
/*           ENDDO                                 */

 /* CUSTOM SHEET */
/*           IF         (&SELET *EQ '40') THEN(DO) */
/*           CALL       PGM(AN#CF2)                */
/*           ENDDO                                 */

 /* LABEL SCAN CHECK */
             IF         (&SELET *EQ '45') THEN(DO)
             CALL       PGM(AN#RA6) PARM(&NONY &NKOJ &NUKE &NOHZ +
                          &NOBN &REHZ &FLG)
             ENDDO

 /* LINE FEED SERACH */
             IF         (&SELET *EQ '46') THEN(DO)
             CALL       PGM(AN#RG2)
             ENDDO

 /* SHIP HISTORY & FORECAST */
             IF         (&SELET *EQ '47') THEN(DO)
             CALL       PGM(ANBC57)
             ENDDO

 /* DISUSE PARTS INF   T */
             IF         (&SELET *EQ '48') THEN(DO)
             CALL       PGM(ANAC3L)
             ENDDO

 /* RETURNABLE SHIPMENT HISTORY(# OF BOX) */
             IF         (&SELET *EQ '49') THEN(DO)
             CALL       PGM(ANBC58)
             ENDDO

 /* CREATE ASN DATA GENTRAN */
             IF         (&SELET *EQ '50') THEN(DO)
             CALL       PGM(TOBJ1/AN#C0KTST)
             ENDDO

 /* FORECAST VS. SETTIGN QTY */
             IF         (&SELET *EQ '51') THEN(DO)
             CALL       PGM(ANBC56)
             ENDDO

 /* ASN PATTERN FILE MAINTENANCE */
             IF         (&SELET *EQ '52') THEN(DO)
             CALL       PGM(ANFR05)
             ENDDO

 /* MAINTENANCE ADDRESS MASTER */
/*           IF         (&SELET *EQ '60') THEN(DO) */
/*           CALL       PGM(AB#RFT) PARM(&USID)    */
/*           ENDDO                                 */

 /* MAINTENANCE ROUTE MASTER */
/*           IF         (&SELET *EQ '61') THEN(DO) */
/*           CALL       PGM(ABFR01)                */
/*           ENDDO                                 */

 /* MAINTENANCE BIN/ ROUTE MASTER */
/*           IF         (&SELET *EQ '62') THEN(DO) */
/*           CALL       PGM(ABFR04)                */
/*           ENDDO                                 */

 /* MAINTENANCE CUM. MASTER */
             IF         (&SELET *EQ '63') THEN(DO)
             STRDFU     OPTION(1 1) DFUPGM(HOBJ1/DANDR3) +
                          FILE(HFILE1/ABRAP01)
             ENDDO

 /* CUM. LIST BY PLANT DOCK */
             IF         (&SELET *EQ '70') THEN(DO)
             RUNQRY     QRY(QANDR4)
             ENDDO

 /* PRINT FUTURE ORDER INFORMATION */
/*           IF         (&SELET *EQ '71') THEN(DO) */
/*           CALL       PGM(AB#CFS)                */
/*           ENDDO                                 */

 /* NOTE INQUIRY */
/*           IF         (&SELET *EQ '80') THEN(DO) */
/*           CALL       PGM(AB#RFR)                */
/*           ENDDO                                 */

 /* FABRICATION & RAW MATERIAL INQUIRY */
             IF         (&SELET *EQ '81') THEN(DO)
             CALL       PGM(AN#RFU)
             ENDDO

 /* RESET CUM QTY             */
/*           IF         COND(&SELET *EQ 'AG' *AND &IN88 *EQ '0') +    */
/*                        THEN(DO)                                    */
/*           CALL       PGM(AB#CFY)                                   */
/*           CHGVAR     VAR(&SELET) VALUE('  ')                       */
/*           GOTO       STP1                                          */
/*           ENDDO                                                    */

/*           IF         COND(&SELET *EQ 'AG' *AND &IN88 *EQ '1') +    */
/*                        THEN(DO)                                    */
/*           CHGVAR     VAR(&MSG) VALUE('YOU ARE NOT SUPPOSED TO DO + */
/*                        THIS JOB.')                                 */
/*           CHGVAR     VAR(&IN99) VALUE('1')                         */
/*           CHGVAR     VAR(&SELET) VALUE('  ')                       */
/*           GOTO       STP2                                          */
/*           ENDDO                                                    */

             CHGVAR     VAR(&SELET) VALUE('  ')
             GOTO       STP2

 END:
             ENDPGM
