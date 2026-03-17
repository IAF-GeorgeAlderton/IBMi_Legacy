             PGM        PARM(&LIBL &FILE &ANS)
             /** JYUCR2 **********************************************/
             /*  RESULTS TRANSFER SUB PROGRAM (JOBQ)                 */
             /*                      CONTROL-ID.  : JYUCR2 <CLP>     */
             /*                      CREATE DATE  : 2015.05.27       */
             /*                      AUTHOR.      :                  */
             /********************************************** JYUCR2 **/
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ACZFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACZSRC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACZWFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FLG)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&LIBL)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CNT) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&FLGFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WCNT) TYPE(*CHAR) LEN(5)
             DCL        VAR(&ANS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FLGREC) TYPE(*DEC) LEN(10 0)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGJOB     RUNPTY(20)

          /* CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG +
                          &PDEVT &PIGCD &USER &ACZFILE &ACZSRC +
                          &ACZWFILE) */

             CHKOBJ     OBJ(&LIBL) OBJTYPE(*LIB)
             MONMSG     MSGID(CPF9801) EXEC(CRTLIB LIB(&LIBL))

             CHGVAR     VAR(&FLGFILE) VALUE('SUBFLG    ')

             CHKOBJ     OBJ(&LIBL/&FLGFILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&LIBL/&FLGFILE) RCDLEN(64) WAITFILE(60))

             CHKOBJ     OBJ(&LIBL/&FILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF FILE(&LIBL/&FILE) +
                          RCDLEN(512) TEXT(&LIBL) SIZE(50000 10000) +
                          WAITFILE(60))

             CHGVAR     VAR(&CNT) VALUE(1)
             /*--------------------------------------*/
             /* SUBFLG --- &LIBL/&FLGFILE            */
             /*   0 :RESULTS TRANSMISSION PERMISSION.*/
             /*   1 :RESULTS ARE BEING MADE.         */
             /*   2 :RESULTS HAVE BEEN TRANSMITTED.  */
             /*   3 :THERE ARE NO RESULTS.           */
             /*   4 :RESULTS COMMUNICATION SUCCESS.  */
             /*   5 :RESULTS RE-DEMAND.              */
             /*   6 :OK ANSWER WITHOUT RESULTS.      */
             /*   7 :TIME-OUT.                       */
             /*   8 :                                */
             /*   9 :THE FLAG IS ABNORMAL.           */
             /*--------------------------------------*/
             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(JYURR2) PARM('W' '0' &LIBL &FLGFILE &WCNT)
             DLTOVR     FILE(*ALL)

#STEP1:      DLYJOB     DLY(5)

#STEP1_1:    CHGVAR     VAR(&FLGREC) VALUE(0)
             RTVMBRD    FILE(&LIBL/&FLGFILE) NBRCURRCD(&FLGREC)
             MONMSG     MSGID(CPF9810 CPF9812)
             IF         COND(&FLGREC *EQ 0) THEN(DO)
             DLYJOB     DLY(1)
             GOTO       #STEP1_1
             ENDDO

             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(JYURR2) PARM('R' &FLG &LIBL &FLGFILE +
                          &WCNT)
             DLTOVR     FILE(*ALL)

             IF         COND(&FLG *EQ '0') THEN(GOTO CMDLBL(#STEP4))
             IF         COND(&FLG *EQ '1') THEN(GOTO CMDLBL(#STEP4))
             IF         COND(&FLG *EQ '2') THEN(GOTO CMDLBL(#STEP2))
             IF         COND(&FLG *EQ '3') THEN(GOTO CMDLBL(#STEP3))
             IF         COND(&FLG *EQ '5') THEN(GOTO CMDLBL(#STEP4))
             GOTO       CMDLBL(#STEP5)
#STEP2:      /*---------------------------------*/
             /* THERE IS DATA.CEHCK RESULT DATA */
             /*---------------------------------*/

             /* NO FILE */
             CHKOBJ     OBJ(&LIBL/&FILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(JYURR2) PARM('W' '5' &LIBL &FLGFILE &WCNT)
             DLTOVR     FILE(*ALL)
             GOTO       CMDLBL(#STEP4)
             ENDDO

             /* ZERO */
             DLYJOB     DLY(3)
             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(&LIBL/&FILE) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(JYURR2) PARM('W' '5' &LIBL &FLGFILE &WCNT)
             DLTOVR     FILE(*ALL)
             GOTO       CMDLBL(#STEP4)
             ENDDO

             /* THE NUMBER OF RECORDS IS DIFFERENT.*/
             CHGVAR     VAR(&ERR) VALUE(' ')
             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FILE)
             CALL       PGM(JYURR3) PARM(&REC &ERR &WCNT)
             DLTOVR     FILE(*ALL)
             IF         COND(&ERR *EQ 'E') THEN(DO)
             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(JYURR2) PARM('W' '5' &LIBL &FLGFILE &WCNT)
             DLTOVR     FILE(*ALL)
             GOTO       CMDLBL(#STEP4)
             ENDDO

             /* DATA IS NORMAL. */
             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(JYURR2) PARM('W' '4' &LIBL &FLGFILE &WCNT)
             DLTOVR     FILE(*ALL)
             CHGVAR     VAR(&ANS) VALUE('0')
             GOTO       CMDLBL(#END)

#STEP3:      /*-------------------*/
             /* THERE IS NO DATA. */
             /*-------------------*/
             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(JYURR2) PARM('W' '6' &LIBL &FLGFILE &WCNT)
             DLTOVR     FILE(*ALL)
             CHGVAR     VAR(&ANS) VALUE('1')
             GOTO       CMDLBL(#END)

#STEP4:
             /*---------------------*/
             /* RE-TRIAL PROCESSING */
             /*---------------------*/
             CHGVAR     VAR(&CNT) VALUE(&CNT + 1)
      /**    IF         COND(&CNT *GT 30) THEN(DO)  **/
             IF         COND(&CNT *GT 90) THEN(DO)
             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(JYURR2) PARM('W' '7' &LIBL &FLGFILE &WCNT)
             DLTOVR     FILE(*ALL)
             CHGVAR     VAR(&ANS) VALUE('1')
             GOTO       CMDLBL(#END)
             ENDDO
             GOTO       CMDLBL(#STEP1)

#STEP5:      /*---------------------*/
             /* ABNORMAL PROCESSING */
             /*---------------------*/
             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(JYURR2) PARM('W' '9' &LIBL &FLGFILE &WCNT)
             DLTOVR     FILE(*ALL)
             CHGVAR     VAR(&ANS) VALUE('1')
             GOTO       CMDLBL(#END)

#END:        ENDPGM
