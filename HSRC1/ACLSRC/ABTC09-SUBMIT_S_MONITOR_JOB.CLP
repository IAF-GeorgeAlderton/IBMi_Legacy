             PGM
             /** ABTC09 *****************************************/
             /*  SUBMIT S_MONITOR JOB                           */
             /*                 CREATE DATE  : 2019.11.19       */
             /*                 AUTHOR.      : T.SAKAKI         */
             /*  ADD JOB TO QGPL/@QSTRUP (AFTER IPL)            */
             /***************************************** ABTC09 **/
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJL)   TYPE(*CHAR) LEN(10)

             CHGJOB     RUNPTY(20)

             RTVJOBA    USER(&USER)
             CHGVAR     VAR(&OBJL) VALUE('TOBJ1     ')

             IF         (&USER *NE 'TEST      ') DO
             CHGVAR     VAR(&USER) VALUE('QPGMR     ')
             CHGVAR     VAR(&OBJL) VALUE('HOBJ1     ')
             ENDDO

 #STEP1:
             DLTDTAARA  DTAARA(&OBJL/ABTR00ACT)
             MONMSG     MSGID(CPF2105)
             DLTDTAARA  DTAARA(&OBJL/ABTR20ACT)
             MONMSG     MSGID(CPF2105)

 #STEP2:
             SBMJOB     CMD(CALL PGM(ABTC00)) JOB(S_MONITOR) +
                          JOBD(QBATCH4) JOBQ(JOBQ4) USER(&USER) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD)

 #END:       ENDPGM
