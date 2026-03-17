             PGM
             /** ENDC10 ******************************************/
             /*  PROGRAM NAME : ENDJOB 実行プログラム          */
             /*  PROGRAM ID   : ENDC10                           */
             /*  CREATE DATE  : 2004.08.30                       */
             /*  AUTHOR       : A.MAMIYA                         */
             /****************************************** ENDC10 **/
             DCL        VAR(&SEQ) TYPE(*DEC) LEN(3 0) VALUE(0)
 @STEP1:
             /*------------------------------*/
             /* 60秒間隔でENDJOB FILE確認*/
             /*------------------------------*/
             DLYJOB     DLY(60)
             CALL       PGM(ENDR10)

             /*----------------------------*/
             /* 60回監視でジョブの再投入 */
             /*----------------------------*/
             CHGVAR     VAR(&SEQ) VALUE(&SEQ +1)
             IF         COND(&SEQ *LT 60) THEN(GOTO CMDLBL(@STEP1))
 @STEP2:
             DLYJOB     DLY(5)
             DLTDTAARA  DTAARA(HFILE1/ENDCP1ACT)
             MONMSG     MSGID(CPF2105) EXEC(GOTO CMDLBL(@STEP3))
             MONMSG     MSGID(CPF2114) EXEC(GOTO CMDLBL(@STEP2))

 @STEP3:
             CALL       PGM(ENDCP1)
 @END:
             ENDPGM
