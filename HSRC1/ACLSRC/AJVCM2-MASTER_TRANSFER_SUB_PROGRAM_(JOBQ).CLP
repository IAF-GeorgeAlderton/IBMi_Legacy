             PGM        PARM(&LIBL &FILE &TRNFILE &ANS)
             /** AJVCM2 **********************************************/
             /*  MASTER TRANSFER SUB PROGRAM (JOBQ)                  */
             /*                      CONTROL-ID.  : AJVCM1 <CLP>     */
             /*                      CREATE DATE  : 2003.06.09       */
             /*                      AUTHOR.      : A.MAMIYA.        */
             /********************************************** AJVCM2 **/
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ATCFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ATCSRC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ATCWFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FLG)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&LIBL)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ANS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CNT) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WCNT) TYPE(*CHAR) LEN(5)
             DCL        VAR(&FLGFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TRNFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ANS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FLGREC) TYPE(*DEC) LEN(10 0)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGJOB     RUNPTY(20)

          /* CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG +
                          &PDEVT &PIGCD &USER &ATCFILE &ATCSRC +
                          &ATCWFILE) */

             CHGVAR     VAR(&ATCWFILE) VALUE('HWFILE1   ')

             CHKOBJ     OBJ(&LIBL) OBJTYPE(*LIB)
             MONMSG     MSGID(CPF9801) EXEC(CRTLIB LIB(&LIBL))

             CHGVAR     VAR(&FLGFILE) VALUE('SUBFLG    ')

             CHKOBJ     OBJ(&LIBL/&FLGFILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&LIBL/&FLGFILE) RCDLEN(64) WAITFILE(60))
             CHGVAR     VAR(&CNT) VALUE(1)
             /*-----------------------------------*/
             /* SUBFLG --- &LIBL/&FLGFILE         */
             /*   0 :MASTERING IS BEING MADE.     */
             /*   1 :MASTERING MAKING COMPLETION  */
             /*   2 :THERE IS NOT MASTERING.      */
             /*   3 :MASTERING IS BEING RECEIVED. */
             /*   4 :MASTERING RECEPTION SUCCESS  */
             /*   5 :MASTERING RECEPTION FAILURE. */
             /*   6 :OK ANSWER WITHOUT MASTERING. */
             /*   7 :TIME-OUT.                    */
             /*   8 :                             */
             /*   9 :THE FLAG IS ABNORMAL.        */
             /*-----------------------------------*/
             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(AJVRM2) PARM('W' '0' &LIBL &FLGFILE &WCNT)
             DLTOVR     FILE(*ALL)

             /*-------------------*/
             /* CEHCK MASTER DATA */
             /*-------------------*/
             CHKOBJ     OBJ(&ATCWFILE/&FILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(AJVRM2) PARM('W' '2' &LIBL &FLGFILE &WCNT)
             DLTOVR     FILE(*ALL)
             GOTO       #STEP1
             ENDDO

             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(&ATCWFILE/&FILE) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(AJVRM2) PARM('W' '2' &LIBL &FLGFILE &WCNT)
             DLTOVR     FILE(*ALL)
             GOTO       #STEP1
             ENDDO
             /*----------------------*/
             /* CREATE TRANSFER DATA */
             /*----------------------*/
             DLTF       FILE(&LIBL/&TRNFILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&LIBL/&TRNFILE) RCDLEN(512) SIZE(100000 +
                          10000) WAITFILE(60)

             OVRDBF     FILE(INPUT) TOFILE(&ATCWFILE/&FILE)
             OVRDBF     FILE(OUTPUT) TOFILE(&LIBL/&TRNFILE)
             CALL       PGM(AJVRM3) PARM(&REC &ATCWFILE &FILE)
             DLTOVR     FILE(*ALL)
             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(AJVRM2) PARM('W' '1' &LIBL &FLGFILE &WCNT)
             DLTOVR     FILE(*ALL)
#STEP1:
             DLYJOB     DLY(5)

#STEP1_1:    CHGVAR     VAR(&FLGREC) VALUE(0)
             RTVMBRD    FILE(&LIBL/&FLGFILE) NBRCURRCD(&FLGREC)
             MONMSG     MSGID(CPF9810 CPF9812)
             IF         COND(&FLGREC *EQ 0) THEN(DO)
             DLYJOB     DLY(1)
             GOTO       #STEP1_1
             ENDDO

             CHGVAR     VAR(&WCNT) VALUE(&REC)
             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(AJVRM2) PARM('R' &FLG &LIBL &FLGFILE &WCNT)
             DLTOVR     FILE(*ALL)

             IF         COND(&FLG *EQ '1') THEN(GOTO CMDLBL(#STEP2))
             IF         COND(&FLG *EQ '2') THEN(GOTO CMDLBL(#STEP2))
             IF         COND(&FLG *EQ '3') THEN(GOTO CMDLBL(#STEP2))
             IF         COND(&FLG *EQ '4') THEN(GOTO CMDLBL(#STEP3))
             IF         COND(&FLG *EQ '5') THEN(GOTO CMDLBL(#STEP3))
             IF         COND(&FLG *EQ '6') THEN(GOTO CMDLBL(#STEP3))
             GOTO       CMDLBL(#STEP4)

#STEP2:      /*---------------------*/
             /* RE-TRIAL PROCESSING */
             /*---------------------*/
             CHGVAR     VAR(&CNT) VALUE(&CNT + 1)
             IF         COND(&CNT *GT 30) THEN(DO)
             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(AJVRM2) PARM('W' '7' &LIBL &FLGFILE &WCNT)
             DLTOVR     FILE(*ALL)
             CHGVAR     VAR(&ANS) VALUE('1')
             GOTO       CMDLBL(#END)
             ENDDO
             GOTO #STEP1
#STEP3:      /*--------------------*/
             /* PROCESSING USUALLY */
             /*--------------------*/
             CHGVAR     VAR(&ANS) VALUE('0')
             IF         COND(&FLG *EQ '5') THEN(CHGVAR VAR(&ANS) +
                          VALUE('1'))
             GOTO       CMDLBL(#END)
#STEP4:      /*---------------------*/
             /* ABNORMAL PROCESSING */
             /*---------------------*/
             OVRDBF     FILE(INPUT) TOFILE(&LIBL/&FLGFILE)
             CALL       PGM(AJVRM2) PARM('W' '9' &LIBL &FLGFILE &WCNT)
             DLTOVR     FILE(*ALL)
             CHGVAR     VAR(&ANS) VALUE('1')
             GOTO       CMDLBL(#END)

#END:        ENDPGM
