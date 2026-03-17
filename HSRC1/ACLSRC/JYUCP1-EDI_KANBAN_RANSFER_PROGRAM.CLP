             PGM
             /** JYUCP1 *****************************************/
             /*  EDI KANBAN              TRANSFER PROGRAM       */
             /*                 CONTROL-ID.  : JYUCP1 <CLP>     */
             /*                 CREATE DATE  : 2003.06.20       */
             /*                 AUTHOR.      : KATOGI           */
             /***************************************** JYUCP1 **/
             DCLF       FILE(JYUPWP1)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NUKI) TYPE(*CHAR) LEN(8)
             DCL        VAR(&OBJL) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGJOB     RUNPTY(20)

             CHKOBJ     OBJ(&OBJL/JYUCP1ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(#STEP1))
             CHGVAR     VAR(&IN03) VALUE('1')
             GOTO       #STEP2
 #STEP1:
 #STEP2:
             SNDRCVF    DEV(&WSID) RCDFMT(JYUPWP11)
             CHGVAR     VAR(&IN99) VALUE('0')
             IF         (&IN01 *EQ '1') GOTO #END
             IF         (&IN03 *EQ '1') GOTO #STEP2
             IF         (&IN05 *EQ '0') GOTO #STEP2

 #STEP3:
             CRTDTAARA  DTAARA(&OBJL/JYUCP1ACT) TYPE(*CHAR) +
                          LEN(10) TEXT('THE COMMUNICATION JOB IS +
                          STARTING .')

             CLROUTQ    OUTQ(QUSRSYS/FAOUTQ)

             DLTDTAARA  DTAARA(&OBJL/JYUCM1ACT)
             MONMSG     MSGID(CPF2105)


             DLTDTAARA  DTAARA(&OBJL/JYUCR1ACT)
             MONMSG     MSGID(CPF2105)

             SBMJOB     JOB(EDI_R) JOBD(QBATCH) JOBQ(QBATCH) +
                          RTGDTA(*JOBD) RQSDTA('CALL PGM(JYUCR1)') +
                          INLLIBL(*CURRENT)

             SBMJOB     JOB(EDI_S) JOBD(QBATCH) JOBQ(QBATCH) +
                          RTGDTA(*JOBD) RQSDTA('CALL PGM(JYUCM1)') +
                          INLLIBL(*CURRENT)
 #END:       ENDPGM
