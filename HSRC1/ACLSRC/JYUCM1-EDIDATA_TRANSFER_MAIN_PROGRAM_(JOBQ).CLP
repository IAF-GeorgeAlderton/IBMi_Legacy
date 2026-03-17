             PGM
             /** JYUCM1 **********************************************/
             /*  EDIDATA TRANSFER MAIN PROGRAM  (JOBQ)               */
             /*                      CONTROL-ID.  : JYUCM1 <CLP>     */
             /*                      CREATE DATE  : 2015.05.21       */
             /*                      AUTHOR.      : MSK.             */
             /********************************************** JYUCM1 **/
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&OBJL)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WNBR)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&FLG)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&LIBL)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&SUBLIBL)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&MASFILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TRNFILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FLGFILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&ANS)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&FLGREC)   TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&OUTR)     TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&CHKFLG) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&WNBR)
             CHGJOB     RUNPTY(20)

             CHGVAR     VAR(&OBJL) VALUE('HOBJ1     ')
             /*--------------------------------*/
             /* CANCEL  COMMUNICATION PROGRAM  */
             /*--------------------------------*/
             CALL       PGM(JYUCM4) PARM(&USER &WNBR)

             CHGVAR     VAR(&LIBL) VALUE('EDI_M     ')
             CHGVAR     VAR(&FLGFILE) VALUE('MAINFLG   ')

             CHKOBJ     OBJ(&LIBL/&FLGFILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&LIBL/&FLGFILE) RCDLEN(64) WAITFILE(60))
             /*-----------------------------------*/
             /* MAINFLG --- &LIBL/&FLGFILE        */
             /*    0 :INITIAL STATE               */
             /*    1 :EDIDATA MAKING DEMAND       */
             /*    2 :EDIDATA MAKING COMPLETION   */
             /*    3 :THERE IN NO EDIDATA         */
             /*    4 :EDIDATA MAKING READY        */
             /*    9 :THE FLAG IS ABNORMAL.       */
             /*-----------------------------------*/
#STEP0:
             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(JYURM1) PARM('W' '0' &LIBL &FLGFILE)
             DLTOVR     FILE(*ALL)
#STEP1:
             DLYJOB     DLY(10)

             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(JYURM1) PARM('R' &FLG &LIBL &FLGFILE)
        /*メインフラグが０だったら未発行データチェック*/
             IF         COND(&FLG *EQ '0') THEN(DO)
             CALL       PGM(AL#R78) PARM(&CHKFLG)
        /*未発行データがあったらメインフラグを４に変更*/
             IF         COND(&CHKFLG *EQ '1') THEN(DO)
             CALL       PGM(JYURM1) PARM('W' '4' &LIBL &FLGFILE)
             ENDDO
             ENDDO
             DLTOVR     FILE(*ALL)

#STEP1_1:    CHGVAR     VAR(&FLGREC) VALUE(0)
             RTVMBRD    FILE(&LIBL/&FLGFILE) NBRCURRCD(&FLGREC)
             MONMSG     MSGID(CPF9810 CPF9812)
             IF         COND(&FLGREC *EQ 0) THEN(DO)
             DLYJOB     DLY(1)
             GOTO       #STEP1_1
             ENDDO

             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(JYURM1) PARM('R' &FLG &LIBL &FLGFILE)
             DLTOVR     FILE(*ALL)

             IF         COND(&FLG *EQ '0') THEN(GOTO CMDLBL(#STEP1))
             IF         COND(&FLG *EQ '1') THEN(GOTO CMDLBL(#STEP2))
             IF         COND(&FLG *EQ '3') THEN(GOTO CMDLBL(#STEP0))
             IF         COND(&FLG *EQ '4') THEN(GOTO CMDLBL(#STEP1))

             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(JYURM1) PARM('W' '9' &LIBL &FLGFILE)
             DLTOVR     FILE(*ALL)
             GOTO       CMDLBL(#STEP0)
#STEP2:
             CRTDTAARA  DTAARA(&OBJL/JYUCM1ACT) TYPE(*CHAR) +
                          LEN(10) TEXT('COMMUNICATION PROCESSING IS +
                          STARTING.')

             /*-------------------*/
             /* CREATE EDIDATA    */
             /*-------------------*/
             CHGVAR     VAR(&OUTR)  VALUE(0)
             CALL       PGM(AL#C71) PARM(&OUTR)
/**!**!**    CALL       PGM(      ) PARM(&OUTR)            **!**!**/

             IF         COND(&OUTR *EQ 0)  +
             THEN(DO)
                 OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
                 CALL       PGM(JYURM1) PARM('W' '3' &LIBL &FLGFILE)
                 DLTOVR     FILE(*ALL)
             DLTDTAARA  DTAARA(&OBJL/JYUCM1ACT)
             MONMSG     MSGID(CPF2105)
                 GOTO       CMDLBL(#STEP1)
             ENDDO
             ELSE (DO)
                 OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
                 CALL       PGM(JYURM1) PARM('W' '2' &LIBL &FLGFILE)
                 DLTOVR     FILE(*ALL)
             ENDDO

             /*--------------------*/
             /* EDIDATA   TRANSFER */
             /*--------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('EDI_MST01 ')
             CHGVAR     VAR(&MASFILE) VALUE('EDIDATA   ')
             CHGVAR     VAR(&TRNFILE) VALUE('MASTER    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(JYUCM2) +
                        PARM(&SUBLIBL &MASFILE &TRNFILE &ANS)
             DLTOVR     FILE(*ALL)


             DLTDTAARA  DTAARA(&OBJL/JYUCM1ACT)
             MONMSG     MSGID(CPF2105)

             GOTO       CMDLBL(#STEP0)

#END:        ENDPGM
