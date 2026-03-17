             PGM
             /** AJVCM1 **********************************************/
             /*  MASTER TRANSFER MAIN PROGRAM  (JOBQ)                */
             /*                      CONTROL-ID.  : AJVCM1 <CLP>     */
             /*                      CREATE DATE  : 2003.06.09       */
             /*                      AUTHOR.      : A.MAMIYA.        */
             /*  %0001 ADD JCA,JCB,JC9   T.SAKAKI   2016.11.21       */
             /*  %0002 ADD SAITONY_MST   Y.MAEDA    2019.01.11       */
             /********************************************** AJVCM1 **/
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WNBR)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&FLG)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&LIBL)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&SUBLIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MASFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TRNFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FLGFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ANS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FLGREC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&TEST) TYPE(*CHAR) LEN(1) VALUE('0')

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&WNBR)
             CHGJOB     RUNPTY(20)


             /*--------------------------------*/
             /* CANCEL  COMMUNICATION PROGRAM  */
             /*--------------------------------*/
             CALL       PGM(AJVCM4) PARM(&USER &WNBR)

             CHGVAR     VAR(&LIBL) VALUE('MEKI_M    ')
             CHGVAR     VAR(&FLGFILE) VALUE('MAINFLG   ')

             CHKOBJ     OBJ(&LIBL/&FLGFILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&LIBL/&FLGFILE) RCDLEN(64) WAITFILE(60))
             /*-----------------------------------*/
             /* MAINFLG --- &LIBL/&FLGFILE        */
             /*    0 :INITIAL STATE               */
             /*    1 :MASTERING MAKING DEMAND     */
             /*    2 :MASTERING MAKING COMPLETION */
             /*    9 :THE FLAG IS ABNORMAL.       */
             /*-----------------------------------*/
#STEP0:
             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(AJVRM1) PARM('W' '0' &LIBL &FLGFILE)
             DLTOVR     FILE(*ALL)
#STEP1:
             IF         COND(&TEST *EQ '0') THEN(DO)
             DLYJOB     DLY(30)
             ENDDO

          /* CREATE LIMITATION MASTER  */
             CALL       PGM(AJVC10)

#STEP1_1:    CHGVAR     VAR(&FLGREC) VALUE(0)
             RTVMBRD    FILE(&LIBL/&FLGFILE) NBRCURRCD(&FLGREC)
             MONMSG     MSGID(CPF9810 CPF9812)
             IF         COND(&FLGREC *EQ 0) THEN(DO)
             DLYJOB     DLY(1)
             GOTO       #STEP1_1
             ENDDO

             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(AJVRM1) PARM('R' &FLG &LIBL &FLGFILE)
             DLTOVR     FILE(*ALL)

             IF         COND(&FLG *EQ '0') THEN(GOTO CMDLBL(#STEP1))
             IF         COND(&FLG *EQ '1') THEN(GOTO CMDLBL(#STEP2))

             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(AJVRM1) PARM('W' '9' &LIBL &FLGFILE)
             DLTOVR     FILE(*ALL)
             GOTO       CMDLBL(#STEP0)
#STEP2:
             CRTDTAARA  DTAARA(HOBJ1/AJVCM1ACT) TYPE(*CHAR) +
                          LEN(10) TEXT('COMMUNICATION PROCESSING IS +
                          STARTING.')
             /*-------------------*/
             /* CREATE F/A MASTER */
             /*-------------------*/
             CALL       PGM(AJDC4T)

             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(AJVRM1) PARM('W' '2' &LIBL &FLGFILE)
             DLTOVR     FILE(*ALL)

             /*--------------------*/
             /* BZ-MASTER TRANSFER */
             /*--------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_MST01')
             CHGVAR     VAR(&MASFILE) VALUE('AJSWP15   ')
             CHGVAR     VAR(&TRNFILE) VALUE('MASTER    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCM2) PARM(&SUBLIBL &MASFILE &TRNFILE +
                          &ANS)
             DLTOVR     FILE(*ALL)

             /*--------------------------*/
             /* OPERETER MASTER TRANSFER */
             /*--------------------------*/
             CALL       PGM(AJSCC0)

             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_MST02')
             CHGVAR     VAR(&MASFILE) VALUE('AJSWPB1   ')
             CHGVAR     VAR(&TRNFILE) VALUE('MASTER    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCM2) PARM(&SUBLIBL &MASFILE &TRNFILE +
                          &ANS)
             IF         COND(&ANS *EQ '0') THEN(DO)
             ENDDO
             DLTOVR     FILE(*ALL)

             /*---------------------*/
             /* DKR-MASTER TRANSFER */
             /*---------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_MST03')
             CHGVAR     VAR(&MASFILE) VALUE('AJSWP19   ')
             CHGVAR     VAR(&TRNFILE) VALUE('MASTER    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCM2) PARM(&SUBLIBL &MASFILE &TRNFILE +
                          &ANS)
             DLTOVR     FILE(*ALL)

             /*---------------------*/
             /* JC1-MASTER TRANSFER */
             /*---------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_MST04')
             CHGVAR     VAR(&MASFILE) VALUE('AJHWP21   ')
             CHGVAR     VAR(&TRNFILE) VALUE('MASTER    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCM2) PARM(&SUBLIBL &MASFILE &TRNFILE +
                          &ANS)
             DLTOVR     FILE(*ALL)

             /*---------------------*/
             /* JC2-MASTER TRANSFER */
             /*---------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_MST05')
             CHGVAR     VAR(&MASFILE) VALUE('AJHWP22   ')
             CHGVAR     VAR(&TRNFILE) VALUE('MASTER    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCM2) PARM(&SUBLIBL &MASFILE &TRNFILE +
                          &ANS)
             DLTOVR     FILE(*ALL)

             /*---------------------*/
             /* JC3-MASTER TRANSFER */
             /*---------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_MST06')
             CHGVAR     VAR(&MASFILE) VALUE('AJHWP23   ')
             CHGVAR     VAR(&TRNFILE) VALUE('MASTER    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCM2) PARM(&SUBLIBL &MASFILE &TRNFILE +
                          &ANS)
             DLTOVR     FILE(*ALL)

             /*---------------------*/
             /* JC4-MASTER TRANSFER */
             /*---------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_MST07')
             CHGVAR     VAR(&MASFILE) VALUE('AJHWP24   ')
             CHGVAR     VAR(&TRNFILE) VALUE('MASTER    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCM2) PARM(&SUBLIBL &MASFILE &TRNFILE +
                          &ANS)
             DLTOVR     FILE(*ALL)

             /*---------------------*/
             /* JC5-MASTER TRANSFER */
             /*---------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_MST08')
             CHGVAR     VAR(&MASFILE) VALUE('AJHWP25   ')
             CHGVAR     VAR(&TRNFILE) VALUE('MASTER    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCM2) PARM(&SUBLIBL &MASFILE &TRNFILE +
                          &ANS)
             DLTOVR     FILE(*ALL)

             /*---------------------*/
             /* JC6-MASTER TRANSFER */
             /*---------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_MST09')
             CHGVAR     VAR(&MASFILE) VALUE('AJHWP26   ')
             CHGVAR     VAR(&TRNFILE) VALUE('MASTER    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCM2) PARM(&SUBLIBL &MASFILE &TRNFILE +
                          &ANS)
             DLTOVR     FILE(*ALL)

             /*---------------------*/
             /* DSM-MASTER TRANSFER */
             /*---------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_MST10')
             CHGVAR     VAR(&MASFILE) VALUE('AJSWP13   ')
             CHGVAR     VAR(&TRNFILE) VALUE('MASTER    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCM2) PARM(&SUBLIBL &MASFILE &TRNFILE +
                          &ANS)
             DLTOVR     FILE(*ALL)

             /*------------------------*/
             /* COMBINE PARTIAL MASTER */
             /*------------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_MST11')
             CHGVAR     VAR(&MASFILE) VALUE('AJZWP01   ')
             CHGVAR     VAR(&TRNFILE) VALUE('MASTER    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCM2) PARM(&SUBLIBL &MASFILE &TRNFILE +
                          &ANS)
             DLTOVR     FILE(*ALL)

             /*---------------------*/
             /* JC7-MASTER TRANSFER */
             /*---------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_MST12')
             CHGVAR     VAR(&MASFILE) VALUE('AJHWP27   ')
             CHGVAR     VAR(&TRNFILE) VALUE('MASTER    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCM2) PARM(&SUBLIBL &MASFILE &TRNFILE +
                          &ANS)
             DLTOVR     FILE(*ALL)

             /*---------------------*/
             /* HD(MATERIAL) MASTER */
             /*---------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_MST13')
             CHGVAR     VAR(&MASFILE) VALUE('AJXWP02   ')
             CHGVAR     VAR(&TRNFILE) VALUE('MASTER    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCM2) PARM(&SUBLIBL &MASFILE &TRNFILE +
                          &ANS)
             DLTOVR     FILE(*ALL)

             /*---------------------*/
             /* MATERIAL  MASTER    */
             /*---------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_MST14')
             CHGVAR     VAR(&MASFILE) VALUE('AJXWP01   ')
             CHGVAR     VAR(&TRNFILE) VALUE('MASTER    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCM2) PARM(&SUBLIBL &MASFILE &TRNFILE +
                          &ANS)
             DLTOVR     FILE(*ALL)

             /*---------------------------*/
             /* OUTSOURCE WEIGHTER MASTER */
             /*---------------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_MST15')
             CHGVAR     VAR(&MASFILE) VALUE('AJJWP01   ')
             CHGVAR     VAR(&TRNFILE) VALUE('MASTER    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCM2) PARM(&SUBLIBL &MASFILE &TRNFILE +
                          &ANS)
             DLTOVR     FILE(*ALL)

             /*---------------------*/
             /* JC8-MASTER TRANSFER */
             /*---------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_MST16')
             CHGVAR     VAR(&MASFILE) VALUE('AJHWP28   ')
             CHGVAR     VAR(&TRNFILE) VALUE('MASTER    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCM2) PARM(&SUBLIBL &MASFILE &TRNFILE +
                          &ANS)
             DLTOVR     FILE(*ALL)

    /* %0001  */
             /*---------------------*/
             /* JCA-MASTER TRANSFER */
             /*---------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_MST17')
             CHGVAR     VAR(&MASFILE) VALUE('AJHWP2A   ')
             CHGVAR     VAR(&TRNFILE) VALUE('MASTER    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCM2) PARM(&SUBLIBL &MASFILE &TRNFILE +
                          &ANS)
             DLTOVR     FILE(*ALL)

             /*---------------------*/
             /* JCB-MASTER TRANSFER */
             /*---------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_MST18')
             CHGVAR     VAR(&MASFILE) VALUE('AJHWP2B   ')
             CHGVAR     VAR(&TRNFILE) VALUE('MASTER    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCM2) PARM(&SUBLIBL &MASFILE &TRNFILE +
                          &ANS)
             DLTOVR     FILE(*ALL)

             /*---------------------*/
             /* JC9-MASTER TRANSFER */  /*IN THE FUTURE*/
             /*---------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_MST19')
             CHGVAR     VAR(&MASFILE) VALUE('AJHWP29   ')
             CHGVAR     VAR(&TRNFILE) VALUE('MASTER    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCM2) PARM(&SUBLIBL &MASFILE &TRNFILE +
                          &ANS)
             DLTOVR     FILE(*ALL)

             /* MAEDA 2018.08.08 ---*/
             /* OQ INPROCESS ALGPP01*/
             /*---------------------*/
             CALL       PGM(ALGCC0)
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_MST20')
             CHGVAR     VAR(&MASFILE) VALUE('ALGWP01   ')
             CHGVAR     VAR(&TRNFILE) VALUE('MASTER    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCM2) PARM(&SUBLIBL &MASFILE &TRNFILE +
                          &ANS)
             DLTOVR     FILE(*ALL)

             /* MAEDA 2018.08.08 ----*/
             /* LOQ INPROCESS ALHPP01*/
             /*----------------------*/
             CALL       PGM(ALHCC0)
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_MST21')
             CHGVAR     VAR(&MASFILE) VALUE('ALHWP01   ')
             CHGVAR     VAR(&TRNFILE) VALUE('MASTER    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCM2) PARM(&SUBLIBL &MASFILE &TRNFILE +
                          &ANS)
             DLTOVR     FILE(*ALL)

             /* MAEDA 2019.01.11 ----*/
             /* LIMITATION MASTER MORE THAN 3 TIMES RELOADING */
             /*----------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_MST22')
             CHGVAR     VAR(&MASFILE) VALUE('AJVWP10   ')
             CHGVAR     VAR(&TRNFILE) VALUE('MASTER    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCM2) PARM(&SUBLIBL &MASFILE &TRNFILE +
                          &ANS)
             DLTOVR     FILE(*ALL)

             /*- 2019.04.05 T.SAKASHITA -*/
             /* SB-KRO MASTER            */
             /*--------------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('MEKI_MST23')
             CHGVAR     VAR(&MASFILE) VALUE('ASBWP09   ')
             CHGVAR     VAR(&TRNFILE) VALUE('MASTER    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(AJVCM2) PARM(&SUBLIBL &MASFILE &TRNFILE +
                          &ANS)
             DLTOVR     FILE(*ALL)

   /*--------------------------------------------------*/
             DLTDTAARA  DTAARA(HOBJ1/AJVCM1ACT)
             MONMSG     MSGID(CPF2105)

             GOTO       CMDLBL(#STEP0)

#END:        ENDPGM
