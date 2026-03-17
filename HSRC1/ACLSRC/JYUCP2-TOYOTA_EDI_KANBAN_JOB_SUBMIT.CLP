             PGM
             /** JYUCP2 *****************************************/
             /*  TOYOTA EDI KANBAN JOB SUBMIT                   */
             /*     IS CALLED FROM QGPL/@QSTRUP                 */
             /*                 CONTROL-ID.  : JYUCP2 <CLP>     */
             /*                 CREATE DATE  : 2011.03.16       */
             /*                 AUTHOR.      : Y.MAEDA.         */
             /*  ADD JOB TO QGPL/@QSTRUP (AFTER IPL)            */
             /***************************************** JYUCP2 **/
             DCL        VAR(&OBJL) TYPE(*CHAR) LEN(10)
             CHGJOB     RUNPTY(20)

             CHGVAR     VAR(&OBJL) VALUE('HOBJ1    ')

             CHKOBJ     OBJ(&OBJL/JYUCP1ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(#STEP1))
             GOTO       CMDLBL(#STEP2)
 #STEP1:
             CRTDTAARA  DTAARA(&OBJL/JYUCP1ACT) TYPE(*CHAR) +
                          LEN(10) TEXT('THE COMMUNICATION JOB IS +
                          STARTING .')
 #STEP2:

             DLTDTAARA  DTAARA(&OBJL/JYUCM1ACT)
             MONMSG     MSGID(CPF2105)

             SBMJOB     JOB(EDI_S) JOBD(QBATCH) JOBQ(QBATCH) +
                          RTGDTA(*JOBD) RQSDTA('CALL PGM(JYUCM1)') +
                          INLLIBL(*CURRENT)

             DLTDTAARA  DTAARA(&OBJL/JYUCR1ACT)
             MONMSG     MSGID(CPF2105)

             SBMJOB     JOB(EDI_R) JOBD(QBATCH) JOBQ(QBATCH) +
                          RTGDTA(*JOBD) RQSDTA('CALL PGM(JYUCR1)') +
                          INLLIBL(*CURRENT)
 #END:       ENDPGM
