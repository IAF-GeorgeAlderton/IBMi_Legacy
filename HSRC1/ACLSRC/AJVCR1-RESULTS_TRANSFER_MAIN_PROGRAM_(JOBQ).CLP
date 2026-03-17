             PGM
             /** AJVCR1 **********************************************/
             /*  RESULTS TRANSFER MAIN PROGRAM  (JOBQ)               */
             /*                      CONTROL-ID.  : AJVCR1 <CLP>     */
             /*                      CREATE DATE  : 2003.06.09       */
             /*                      AUTHOR.      : A.MAMIYA.        */
             /*  %0001 T.SAKAKI 08/24/18   ADD CNT1                  */
             /********************************************** AJVCR1 **/
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&OBJL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ATCSRC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ATCWFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WNBR)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&FLG)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&LIBL)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&SUBLIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RSTFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FLGFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ANS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FLGREC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&CNT1) TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&PMSGQ) TYPE(*CHAR) LEN(10) +
                          VALUE('QSYSOPR   ')
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PTTL)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&PMSG)  TYPE(*CHAR) LEN(256)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&WNBR)
             CHGJOB     RUNPTY(20)

             CHGVAR     VAR(&OBJL) VALUE('HOBJ1    ')

             /*--------------------------------*/
             /* CANCEL  COMMUNICATION PROGRAM  */
             /*--------------------------------*/
             CALL       PGM(AJVCR4) PARM(&USER &WNBR)

             CHGVAR     VAR(&LIBL) VALUE('MEKI_R    ')
             CHGVAR     VAR(&FLGFILE) VALUE('MAINFLG   ')

             CHKOBJ     OBJ(&LIBL/&FLGFILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&LIBL/&FLGFILE) RCDLEN(64) WAITFILE(60))
             /*------------------------------------------------*/
             /* MAINFLG --- &LIBL/&FLGFILE                     */
             /*    0 :INITIAL STATE                            */
             /*    1 :RESULTS TRANSMISSION BEGINNING DEMAND    */
             /*    2 :RESULTS TRANSMISSION BEGINNING APPROVAL  */
             /*    9 :THE FLAG IS ABNORMAL.                    */
             /*------------------------------------------------*/
#STEP0:
             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(AJVRR1) PARM('W' '0' &LIBL &FLGFILE)
             DLTOVR     FILE(*ALL)
#STEP1:
             DLYJOB     DLY(30)

#STEP1_1:     /* %0001 */
             IF         COND(&CNT1 *GE 120) THEN(DO)
        /* SEND MESSAGE */
        /*   CHGVAR     VAR(&PKINP) VALUE('GR   ')                      */
        /*   CHGVAR     VAR(&PKOUT) VALUE(' ')                          */
        /*   CHGVAR     VAR(&PMSG) VALUE('''MEKI_R IS NOT WORKING. +    */
        /*                PLEASE CHECK. "G":Continue /  "R":Cancel +    */
        /*                & Retry')                                     */
        /*   CALL       PGM(APLC50) PARM(&PMSG &PKINP &PMSGQ &PKOUT)    */

        /*   IF         COND(&PKOUT *EQ 'G') THEN(DO)                   */
        /*   CHGVAR     VAR(&CNT1) VALUE(0)                             */
        /*   GOTO       #STEP1_1                                        */
        /*   ENDDO                                                      */
        /*   IF         COND(&PKOUT *EQ 'R') THEN(DO)                   */
             GOTO       #STEP0
        /*   ENDDO                                                      */
             ENDDO

   /* MAIN FLAG COMMUNICATION */
             CHGVAR     VAR(&FLGREC) VALUE(0)
             RTVMBRD    FILE(&LIBL/&FLGFILE) NBRCURRCD(&FLGREC)
             MONMSG     MSGID(CPF9810 CPF9812)
             IF         COND(&FLGREC *EQ 0) THEN(DO)
             CHGVAR     VAR(&CNT1) VALUE(&CNT1 + 1)
             DLYJOB     DLY(1)
             GOTO       #STEP1_1
             ENDDO

             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(AJVRR1) PARM('R' &FLG &LIBL &FLGFILE)
             DLTOVR     FILE(*ALL)


             IF         COND(&FLG *EQ '0') THEN(GOTO CMDLBL(#STEP1))
             IF         COND(&FLG *EQ '1') THEN(GOTO CMDLBL(#STEP2))

             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(AJVRR1) PARM('W' '9' &LIBL &FLGFILE)
             DLTOVR     FILE(*ALL)
             GOTO       CMDLBL(#STEP0)
#STEP2:
             CRTDTAARA  DTAARA(&OBJL/AJVCR1ACT) TYPE(*CHAR) +
                          LEN(10) TEXT('COMMUNICATION PROCESSING IS +
                          STARTING')

             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(AJVRR1) PARM('W' '2' &LIBL &FLGFILE)
             DLTOVR     FILE(*ALL)
             /*--------------------*/
             /* BZ LOADING RESULTS */
             /*--------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_RST01')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)
       /*    IF         COND(&ANS *EQ '0') THEN(CALL PGM(AJVRX2))   */
             IF         COND(&ANS *EQ '0') THEN(DO)
             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTFILE) MBROPT(*ADD) +
                          CRTFILE(*YES)
             CALL       PGM(AJSC1A)
             ENDDO
             DLTOVR     FILE(*ALL)
             /*-----------------------------*/
             /* BZ CHROMATE LOADING RESULTS */
             /*-----------------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_RST02')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)
       /*    IF         COND(&ANS *EQ '0') THEN(CALL PGM(AJVRW2))   */
             IF         COND(&ANS *EQ '0') THEN(DO)
             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTFILE) MBROPT(*ADD) +
                          CRTFILE(*YES)
             CALL       PGM(AJSC2A)
             ENDDO
             DLTOVR     FILE(*ALL)
             /*----------------------*/
             /* BZ UNLOADING RESULTS */
             /*----------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_RST03')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)
       /*    IF         COND(&ANS *EQ '0') THEN(CALL PGM(AJVRX1))   */
             IF         COND(&ANS *EQ '0') THEN(DO)
             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTFILE) MBROPT(*ADD) +
                          CRTFILE(*YES)
             CALL       PGM(AJSC1B)
             ENDDO
             DLTOVR     FILE(*ALL)
             /*----------------------------*/
             /* BZ KANBAN PRINTING RESULTS */
             /*----------------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_RST04')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)
     /*      IF         COND(&ANS *EQ '0') THEN(CALL PGM(AJVRW4))    */
             IF         COND(&ANS *EQ '0') THEN(DO)
             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTFILE) MBROPT(*ADD) +
                          CRTFILE(*YES)
             ENDDO
             DLTOVR     FILE(*ALL)
             /*---------------------*/
             /* DKR LOADING RESULTS */
             /*---------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_RST05')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)
       /*    IF         COND(&ANS *EQ '0') THEN(CALL PGM(AJVRW5))   */
             IF         COND(&ANS *EQ '0') THEN(DO)
             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTFILE) MBROPT(*ADD) +
                          CRTFILE(*YES)
             CALL       PGM(AJSCD1)
             ENDDO
             DLTOVR     FILE(*ALL)
             /*-----------------------*/
             /* DKR UNLOADING RESULTS */
             /*-----------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_RST06')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)
       /*    IF         COND(&ANS *EQ '0') THEN(CALL PGM(AJVRW5))   */
             IF         COND(&ANS *EQ '0') THEN(DO)
             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTFILE) MBROPT(*ADD) +
                          CRTFILE(*YES)
             CALL       PGM(AJSCD6)
             ENDDO
             DLTOVR     FILE(*ALL)
             /*-----------------------------*/
             /* DKR KANBAN PRINTING RESULTS */
             /*-----------------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_RST07')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)
      /*     IF         COND(&ANS *EQ '0') THEN(CALL PGM(AJVRW6))*/
             IF         COND(&ANS *EQ '0') THEN(DO)
             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTFILE) MBROPT(*ADD) +
                          CRTFILE(*YES)

             ENDDO
             DLTOVR     FILE(*ALL)
             /*--------------------*/
             /* JC LOADING RESULTS */
             /*--------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_RST08')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)
       /*    IF         COND(&ANS *EQ '0') THEN(CALL PGM(AJVRW5))   */
             IF         COND(&ANS *EQ '0') THEN(DO)
             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTFILE) MBROPT(*ADD) +
                          CRTFILE(*YES)
             CALL       PGM(AJHC11)
             ENDDO
             DLTOVR     FILE(*ALL)
             /*----------------------*/
             /* JC UNLOADING RESULTS */
             /*----------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_RST09')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)
       /*    IF         COND(&ANS *EQ '0') THEN(CALL PGM(AJVRW5))   */
             IF         COND(&ANS *EQ '0') THEN(DO)
             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTFILE) MBROPT(*ADD) +
                          CRTFILE(*YES)
             CALL       PGM(AJHC20)
             ENDDO
             DLTOVR     FILE(*ALL)
             /*----------------------*/
             /* 2ND PRINTING RESULTS */
             /*----------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_RST10')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)
      /*     IF         COND(&ANS *EQ '0') THEN(CALL PGM(AJVRW7)) */
             IF         COND(&ANS *EQ '0') THEN(DO)
             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTFILE) MBROPT(*ADD) +
                          CRTFILE(*YES)

             ENDDO
             DLTOVR     FILE(*ALL)
             /*--------------*/
             /*端数統合実績*/
             /*--------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_RST11')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)
             IF         COND(&ANS *EQ '0') THEN(DO)
             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTFILE) MBROPT(*ADD) +
                          CRTFILE(*YES)
             CALL       PGM(AJZC10)
             ENDDO
             DLTOVR     FILE(*ALL)
             /*--------------------------*/
             /*端数統合かんばん発行実績*/
             /*--------------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_RST12')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)
             IF         COND(&ANS *EQ '0') THEN(DO)
             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTFILE) MBROPT(*ADD) +
                          CRTFILE(*YES)
             CALL       PGM(AJZC30)
             ENDDO
             DLTOVR     FILE(*ALL)
             /*--------------------*/
             /*端数統合エラー実績*/
             /*--------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_RST13')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)
             IF         COND(&ANS *EQ '0') THEN(DO)
             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTFILE) MBROPT(*ADD) +
                          CRTFILE(*YES)
             CALL       PGM(AJZC20)
             ENDDO
             DLTOVR     FILE(*ALL)
             /*-------------------------*/
             /* DKR 2ND LOADING RESULTS */
             /*-------------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_RST14')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)
             IF         COND(&ANS *EQ '0') THEN(DO)
             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTFILE) MBROPT(*ADD) +
                          CRTFILE(*YES)
             CALL       PGM(AJSCD8)
             ENDDO
             DLTOVR     FILE(*ALL)
             /*---------*/
             /* REPORTS */
             /*---------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_RST15')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)
             IF         COND(&ANS *EQ '0') THEN(DO)
             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTFILE) MBROPT(*ADD) +
                          CRTFILE(*YES)
             CALL       PGM(MTAC01)
             ENDDO
             DLTOVR     FILE(*ALL)

             /*-----------*/
             /* HD RESULT */
             /*-----------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_RST16')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)
             IF         COND(&ANS *EQ '0') THEN(DO)
             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTFILE) MBROPT(*ADD) +
                          CRTFILE(*YES)
             CALL       PGM(MTAC10)
             ENDDO
             DLTOVR     FILE(*ALL)

             /*-----------*/
             /*外注計量RESULT */
             /*-----------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_RST17')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)
             IF         COND(&ANS *EQ '0') THEN(DO)
             CALL       PGM(AJUC10)
             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTFILE) MBROPT(*ADD) +
                          CRTFILE(*YES)
             ENDDO
             DLTOVR     FILE(*ALL)

             /*-----------*/
             /*外注計量RESULT */
             /*-----------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_RST18')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)
             IF         COND(&ANS *EQ '0') THEN(DO)
             CALL       PGM(AJUC20)
             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTFILE) MBROPT(*ADD) +
                          CRTFILE(*YES)
             ENDDO
             DLTOVR     FILE(*ALL)

             /*-----------*/
             /*外注品計量かんばん発行RESULT */
             /*-----------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_RST19')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)
             IF         COND(&ANS *EQ '0') THEN(DO)
             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTFILE) MBROPT(*ADD) +
                          CRTFILE(*YES)
             ENDDO
             DLTOVR     FILE(*ALL)

             /*------------*/
             /* DS   計量*/
             /*------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_RST20')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)
             OVRDBF     FILE(RESULT) TOFILE(&SUBLIBL/&RSTFILE)
             CALL       PGM(AJSR1F)
             IF         COND(&ANS *EQ '0') THEN(DO)
             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTFILE) MBROPT(*ADD) +
                          CRTFILE(*YES)
             ENDDO
             DLTOVR     FILE(*ALL)

             /*-------------*/
             /* SB-KRO計量*/
             /*-------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_RST21')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)
             IF         COND(&ANS *EQ '0') THEN(DO)
             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTFILE) MBROPT(*ADD) +
                          CRTFILE(*YES)
             ENDDO
             DLTOVR     FILE(*ALL)

             /*-------------*/
             /* SB-KROかんばん発行*/
             /*-------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_RST22')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)
             IF         COND(&ANS *EQ '0') THEN(DO)
             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTFILE) MBROPT(*ADD) +
                          CRTFILE(*YES)
             ENDDO
             DLTOVR     FILE(*ALL)

             /*-------------*/
             /* STかんばん発行*/
             /*-------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_RST23')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)
             IF         COND(&ANS *EQ '0') THEN(DO)
             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTFILE) MBROPT(*ADD) +
                          CRTFILE(*YES)
             ENDDO
             DLTOVR     FILE(*ALL)

             /*-------------*/
             /* A-PICS2入庫かんばん発行実績*/
             /*-------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_RST24')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)
             IF         COND(&ANS *EQ '0') THEN(DO)
             CALL       PGM(CAAC30)
             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTFILE) MBROPT(*ADD) +
                          CRTFILE(*YES)
             ENDDO
             DLTOVR     FILE(*ALL)

             /*--------------------------*/
             /* BACKUP KANBAN 発行実績 */
             /* OQのブリッジかんばん   */
             /*--------------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_RST25')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)
             IF         COND(&ANS *EQ '0') THEN(DO)
         /** CALL       PGM(XXXXXX) **/
             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTFILE) MBROPT(*ADD) +
                          CRTFILE(*YES)
             ENDDO
             DLTOVR     FILE(*ALL)

             /*------------*/

             DLTDTAARA  DTAARA(&OBJL/AJVCR1ACT)
             MONMSG     MSGID(CPF2105)

             GOTO       CMDLBL(#STEP0)

#END:        ENDPGM
