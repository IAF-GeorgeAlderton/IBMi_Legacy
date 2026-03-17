             PGM
             /** ENDCP1 ******************************************/
             /*  PROGRAM NAME : ENDJOB 実行プログラム          */
             /*  PROGRAM ID   : ENDCP1                           */
             /*  CREATE DATE  : 2004.08.30                       */
             /*  AUTHOR       : A.MAMIYA                         */
             /****************************************** ENDCP1 **/
             CHKOBJ     OBJ(HFILE1/ENDCP1ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@STEP1))
             GOTO       CMDLBL(@END)

 @STEP1:
             CRTDTAARA  DTAARA(HFILE1/ENDCP1ACT) TYPE(*CHAR) +
                          LEN(10) TEXT('ＥＮＤＪＯＢ実行中')

             SBMJOB     CMD(CALL PGM(ENDC10)) JOB(ENDJOB) +
                          JOBD(QBATCH4) JOBQ(JOBQ4) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD)
 @END:
             ENDPGM
