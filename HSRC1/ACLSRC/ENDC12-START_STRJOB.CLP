             PGM        PARM(&PSPGM &PPAR1 &PPAR2 &PSJOB &PJOBD +
                          &PJOBQ &PSDTA &PSLIB &PSFLG)
             /** ENDC12 ******************************************/
             /*  PROGRAM NAME : STRJOB（ジョブの起動）         */
             /*  PROGRAM ID   : ENDC12                           */
             /*  CREATE DATE  : 2004.08.30                       */
             /*  AUTHOR       : A.MAMIYA                         */
             /****************************************** ENDC12 **/
             DCL        VAR(&PSPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPAR1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPAR2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PSJOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PJOBD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PJOBQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PSDTA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PSLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PSFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CNT) TYPE(*DEC) LEN(3 0) VALUE(0)

             /*--------------------------------------------------*/
             /*データエリア指定有りの場合、データエリア確認    */
             /*データエリアが存在した場合は強制的に削除        */
 @STEP1:     /*--------------------------------------------------*/
             IF         COND(&PSDTA *NE '          ') THEN(DO)
             DLTDTAARA  DTAARA(&PSLIB/&PSDTA)
             MONMSG     MSGID(CPF0000)
             ENDDO

             /*-- &PSFLGの値-----------------------------------*/
             /*   '*': 正常にジョブの起動実行                  */
 @STEP2:     /*--------------------------------------------------*/
             CHGVAR     VAR(&PSFLG) VALUE('*')
             /*----------------------*/
             /*パラメーターして無し*/
             /*----------------------*/
             IF         COND(&PPAR1 *EQ '          ') THEN(DO)
             SBMJOB     CMD(CALL PGM(&PSPGM)) JOB(&PSJOB) +
                          JOBD(&PJOBD) JOBQ(&PJOBQ) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD)
             GOTO @END
             ENDDO
             /*----------------------------*/
             /*パラメーター１のみ指定有り*/
             /*----------------------------*/
             IF         COND(&PPAR2 *EQ '          ') THEN(DO)
             SBMJOB     CMD(CALL PGM(&PSPGM) PARM(&PPAR1)) +
                          JOB(&PSJOB) JOBD(&PJOBD) JOBQ(&PJOBQ) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD)
             GOTO @END
             ENDDO
             /*--------------------------------*/
             /*パラメーター１・２共に指定有り*/
             /*--------------------------------*/
             SBMJOB     CMD(CALL PGM(&PSPGM) PARM(&PPAR1 &PPAR2)) +
                          JOB(&PSJOB) JOBD(&PJOBD) JOBQ(&PJOBQ) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD)
 @END:       ENDPGM
