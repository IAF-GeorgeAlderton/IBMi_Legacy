             PGM
             /** AJVCP1 *****************************************/
             /*  MEKI MASTER AND RESULTS TRANSFER PROGRAM       */
             /*                 CONTROL-ID.  : AJVCP1 <CLP>     */
             /*                 CREATE DATE  : 2003.06.20       */
             /*                 AUTHOR.      : A.MAMIYA.        */
             /***************************************** AJVCP1 **/
             DCLF       FILE(AJVPWP1)
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
             DCL        VAR(&NUKI) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGJOB     RUNPTY(20)

          /* CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG +
                          &PDEVT &PIGCD &USER &ATCFILE &ATCSRC +
                          &ATCWFILE) */

             CHKOBJ     OBJ(HOBJ1/AJVCP1ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(#STEP1))
             CHGVAR     VAR(&IN03) VALUE('1')
             GOTO       #STEP2
 #STEP1:
           /*CHGVAR     VAR(&IN02) VALUE('1')*/
 #STEP2:
             SNDRCVF    DEV(&WSID) RCDFMT(AJVPWP11)
             CHGVAR     VAR(&IN99) VALUE('0')
             IF         (&IN01 *EQ '1') GOTO #END
             IF         (&IN03 *EQ '1') GOTO #STEP2
             IF         (&IN05 *EQ '0') GOTO #STEP2

        /*   SNDPGMMSG  MSG('( G ) THE COMMUNICATION JOB IS +        */
        /*                STARTING.   PLEASE DO THE CANCELLATION +   */
        /*                PROCESSING OF THE COMMUNICATION JOB +      */
        /*                PREVIOUSLY.') TOMSGQ(&WSID) MSGTYPE(*INQ) +*/
        /*                KEYVAR(&MBAN)                              */
        /*   RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +     */
        /*                MSG(&ANS)                                  */
        /*                                                           */
        /*   IF         (&ANS *NE 'G') GOTO #STEP1                   */
        /*   IF         (&ANS *EQ 'G') GOTO #END                     */
 #STEP3:
             CRTDTAARA  DTAARA(HOBJ1/AJVCP1ACT) TYPE(*CHAR) +
                          LEN(10) TEXT('THE COMMUNICATION JOB IS +
                          STARTING .')

             CLROUTQ    OUTQ(QUSRSYS/FAOUTQ)

             DLTDTAARA  DTAARA(HOBJ1/AJVCM1ACT)
             MONMSG     MSGID(CPF2105)

       /* 再編成組み込み　2009/2/9 Y.MAEDA  */
       /*    CALL       PGM(AJVCBG)           */

             SBMJOB     JOB(MEKI_M) JOBD(QBATCH) JOBQ(QBATCH) +
                          RTGDTA(*JOBD) RQSDTA('CALL PGM(AJVCM1)') +
                          INLLIBL(*CURRENT)

             DLTDTAARA  DTAARA(HOBJ1/AJVCR1ACT)
             MONMSG     MSGID(CPF2105)

             SBMJOB     JOB(MEKI_R) JOBD(QBATCH) JOBQ(QBATCH) +
                          RTGDTA(*JOBD) RQSDTA('CALL PGM(AJVCR1)') +
                          INLLIBL(*CURRENT)
 #END:       ENDPGM
