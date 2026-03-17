             PGM        PARM(&PJOBM &PUSER &PWNBR &PEDTA &PELIB &PEFLG)
             /** ENDC11 ******************************************/
             /*  PROGRAM NAME : ENDJOB（ジョブの終了）         */
             /*  PROGRAM ID   : ENDC11                           */
             /*  CREATE DATE  : 2004.08.30                       */
             /*  AUTHOR       : A.MAMIYA                         */
             /****************************************** ENDC11 **/
             DCL        VAR(&PJOBM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PWNBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PEDTA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PELIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PEFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CNT) TYPE(*DEC) LEN(3 0) VALUE(0)

             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             /*--------------------------------------------------*/
             /*データエリア指定有りの場合、データエリア確認    */
 @STEP1:     /*--------------------------------------------------*/
             IF         COND(&PEDTA *NE '          ') THEN(DO)
             CHKOBJ     OBJ(&PELIB/&PEDTA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@STEP2))
             GOTO       CMDLBL(@END)
             ENDDO

  /*-- &PEFLGの値-------------------------------------------------*/
  /* '*': 正常にＥＮＤＪＯＢ実行                                  */
  /* '1': ジョブ&3/&2/&1に対して，サブシステムから応答がない。  */
  /* '2': ジョブ&1ユーザー&2ジョブ番号&3が見つからない。    */
  /* '3': ジョブ制御機能は実行されなかった。                      */
  /* '4': ジョブ&3/&2/&1は，この機能に対して正しくないジョブ・タ*/
  /*      イプである。                                            */
  /* '5': ジョブ&3/&2/&1を制御する権限がない。                  */
  /* '6': この機能は実行されなかった。&3/&2/&1は移行状態である。*/
  /* '7': ジョブ&3/&2/&1が*IMMEDオプションですでに終了中であ  */
  /*    : る。                                                    */
  /* '8': ジョブ&3/&2/&1が*CNTRLDですでに終了中である。       */
  /* '9': ジョブが正常に完了（※同ジョブ№が既に終了済みの場合）  */
  /*----------------------------------------------------------------*/
 @STEP2:
             CHGVAR     VAR(&PEFLG) VALUE('*')
             ENDJOB     JOB(&PWNBR/&PUSER/&PJOBM) OPTION(*IMMED)
             MONMSG     MSGID(CPF1317) EXEC(CHGVAR VAR(&PEFLG) +
                          VALUE('1'))
             MONMSG     MSGID(CPF1321) EXEC(CHGVAR VAR(&PEFLG) +
                          VALUE('2'))
             MONMSG     MSGID(CPF1340) EXEC(CHGVAR VAR(&PEFLG) +
                          VALUE('3'))
             MONMSG     MSGID(CPF1343) EXEC(CHGVAR VAR(&PEFLG) +
                          VALUE('4'))
             MONMSG     MSGID(CPF1344) EXEC(CHGVAR VAR(&PEFLG) +
                          VALUE('5'))
             MONMSG     MSGID(CPF1352) EXEC(CHGVAR VAR(&PEFLG) +
                          VALUE('6'))
             MONMSG     MSGID(CPF1361) EXEC(CHGVAR VAR(&PEFLG) +
                          VALUE('7'))
             MONMSG     MSGID(CPF1363) EXEC(CHGVAR VAR(&PEFLG) +
                          VALUE('8'))
       /*    MONMSG     MSGID(CPF1362) EXEC(CHGVAR VAR(&PEFLG) +
                          VALUE('9'))        */

           /*V6R1からCPF1362がMONMSGで拾えなくなったので*/
           /*2012.05.23 T.SAKASHITA                           */
             RCVMSG     MSGTYPE(*LAST) MSGID(&MSGID)
             IF         COND(&MSGID *EQ 'CPF1362') THEN(CHGVAR +
                                       VAR(&PEFLG) VALUE('9'))

@END:        ENDPGM
