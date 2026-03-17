             PGM
             /** ENDCP3 ******************************************/
             /*  PROGRAM NAME : ENDJOB 実行プログラム（ＢＫ後）*/
             /*  PROGRAM ID   : ENDCP3                           */
             /*  CREATE DATE  : 2004.12.19                       */
             /*  AUTHOR       : A.MAMIYA                         */
             /****************************************** ENDCP3 **/
             DLTDTAARA  DTAARA(HFILE1/ENDCP1ACT)
             MONMSG     MSGID(CPF2105)
 @STEP1:
             CRTDTAARA  DTAARA(HFILE1/ENDCP1ACT) TYPE(*CHAR) +
                          LEN(10) TEXT('ＥＮＤＪＯＢ実行中')

             SBMJOB     CMD(CALL PGM(ENDC10)) JOB(ENDJOB) +
                          JOBD(QBATCH4) JOBQ(JOBQ4) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD)
 @END:
             ENDPGM
