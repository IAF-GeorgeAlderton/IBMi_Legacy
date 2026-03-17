             PGM
             /** JYTCR2 **********************************************/
             /*  TOYOTA WEB TRANSFER PROGRAM  (JOBQ) )               */
             /*                      CONTROL-ID.  : JYTCR2 <CLP>     */
             /*                      CREATE DATE  : 2019.02.12       */
             /*                      AUTHOR.      : J.WATANABE       */
             /********************************************************/
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&ATCFILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&ATCSRC)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&ATCWFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WNBR)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&FLG)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&LIBL)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&SUBLIBL)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&RSTFILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FLGFILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&ANS)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&FLGREC)   TYPE(*DEC) LEN(10 0)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&WNBR)
             CHGJOB     RUNPTY(20)

             CHGVAR     VAR(&ATCFILE) VALUE('HFILE1   ')

             /*--------------------------------*/
             /* CANCEL  COMMUNICATION PROGRAM  */
             /*--------------------------------*/
             CALL       PGM(JYUCR4) PARM(&USER &WNBR)

             CHGVAR     VAR(&LIBL) VALUE('EDI_R     ')
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
             CALL       PGM(JYURR1) PARM('W' '0' &LIBL &FLGFILE)
             DLTOVR     FILE(*ALL)
#STEP1:
             DLYJOB     DLY(10)

#STEP1_1:    CHGVAR     VAR(&FLGREC) VALUE(0)
             RTVMBRD    FILE(&LIBL/&FLGFILE) NBRCURRCD(&FLGREC)
             MONMSG     MSGID(CPF9810 CPF9812)
             IF         COND(&FLGREC *EQ 0) THEN(DO)
             DLYJOB     DLY(1)
             GOTO       #STEP1_1
             ENDDO

             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(JYURR1) PARM('R' &FLG &LIBL &FLGFILE)
             DLTOVR     FILE(*ALL)


             IF         COND(&FLG *EQ '0') THEN(GOTO CMDLBL(#STEP1))
             IF         COND(&FLG *EQ '1') THEN(GOTO CMDLBL(#STEP2))

             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(JYURR1) PARM('W' '9' &LIBL &FLGFILE)
             DLTOVR     FILE(*ALL)
             GOTO       CMDLBL(#STEP0)
#STEP2:
             CRTDTAARA  DTAARA(&ATCFILE/JYUCR1ACT) TYPE(*CHAR) +
                          LEN(10) TEXT('COMMUNICATION PROCESSING IS +
                          STARTING')

             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(JYURR1) PARM('W' '2' &LIBL &FLGFILE)
             DLTOVR     FILE(*ALL)

             /*--------------------*/
             /* BZ LOADING RESULTS */
             /*--------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('EDI_RST02 ')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(JYUCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)
             IF         COND(&ANS *EQ '0') THEN(DO)

   /***  PROCESS AFTER RECEIVING DATA **/

             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTFILE) MBROPT(*ADD) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)
             CALL       PGM(JYUC1A)
             ENDDO
             DLTOVR     FILE(*ALL)

             DLTDTAARA  DTAARA(&ATCFILE/JYUCR1ACT)
             MONMSG     MSGID(CPF2105)

             GOTO       CMDLBL(#STEP0)

#END:        ENDPGM
