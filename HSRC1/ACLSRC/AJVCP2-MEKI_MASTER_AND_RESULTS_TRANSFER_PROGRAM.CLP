             PGM
             /** AJVCP2 *****************************************/
             /*  MEKI MASTER AND RESULTS TRANSFER PROGRAM<IPL>  */
             /*                 CONTROL-ID.  : AJVCP2 <CLP>     */
             /*                 CREATE DATE  : 2011.03.16       */
             /*                 AUTHOR.      : Y.MAEDA.         */
             /*  ADD JOB TO QGPL/@QSTRUP (AFTER IPL)            */
             /***************************************** AJVCP2 **/
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&OBJL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NUKI) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGJOB     RUNPTY(20)


             CHGVAR     VAR(&OBJL) VALUE('HOBJ1    ')

             CHKOBJ     OBJ(&OBJL/AJVCP1ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(#STEP1))
             GOTO       CMDLBL(#STEP2)
 #STEP1:
             CRTDTAARA  DTAARA(&OBJL/AJVCP1ACT) TYPE(*CHAR) +
                          LEN(10) TEXT('THE COMMUNICATION JOB IS +
                          STARTING .')
 #STEP2:
             CLROUTQ    OUTQ(QUSRSYS/FAOUTQ)

             DLTDTAARA  DTAARA(&OBJL/AJVCM1ACT)
             MONMSG     MSGID(CPF2105)

             SBMJOB     JOB(MEKI_M) JOBD(QBATCH) JOBQ(QBATCH) +
                          RTGDTA(*JOBD) RQSDTA('CALL PGM(AJVCM1)') +
                          INLLIBL(*CURRENT)

             DLTDTAARA  DTAARA(&OBJL/AJVCR1ACT)
             MONMSG     MSGID(CPF2105)

             SBMJOB     JOB(MEKI_R) JOBD(QBATCH) JOBQ(QBATCH) +
                          RTGDTA(*JOBD) RQSDTA('CALL PGM(AJVCR1)') +
                          INLLIBL(*CURRENT)
 #END:       ENDPGM
