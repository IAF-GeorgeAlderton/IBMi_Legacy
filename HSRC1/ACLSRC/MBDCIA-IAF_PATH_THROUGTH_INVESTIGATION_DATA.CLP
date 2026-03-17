             PGM
             /** MBDCIA *******************************************/
             /*  IAF PATH THROUGTH INVESTIGATION DATA           */
             /*            T.SAKASHITA    2004.01.22              */
             /* ------------------------------------------------- */
             /* JW  2026.01.20 CHG GCLSRC --> ACLSRC              */
             /******************************************* MBDCIA **/
             DCLF       FILE(MBDPWIA)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&DFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WKAI) TYPE(*DEC) LEN(2)
             DCL        VAR(&FILE03) TYPE(*CHAR) LEN(10) VALUE(' ')
             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&FILE03) VALUE('MBDWPS3')

             CHKOBJ     OBJ(MBDCIAACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP1))
 STP0:       SNDPGMMSG  MSG('( C +
                          )現在この処理を他のＴＶで使用中。') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         (&KOTAE *NE 'C') GOTO STP0
             RETURN
             GOTO       @END2

 STP1:       CRTDTAARA  DTAARA(MBDCIAACT) TYPE(*CHAR) LEN(10) +
                          VALUE(&USER) AUT(*ALL)

 STP2:
             SNDRCVF    DEV(&WSID) RCDFMT(MBDPWIA1)
             CHGVAR     VAR(&IN99) VALUE('0')
             /*************/
             /* F1 =終了*/
             /*************/
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@END))
             /*************/
             /* F5 =転送*/
             /*************/
             IF         COND(&IN05 *EQ '1') THEN(GOTO CMDLBL(@GO))
             GOTO       CMDLBL(STP2)

 @GO:
             DLTF       FILE(&FILE03)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(MBDWPIA)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/MBDWPIA) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(25000 5000 4) +
                          LVLCHK(*NO) AUT(*ALL)

             CLRPFM     FILE(MBDPPIA)
             CALL       PGM(MBDRIA)



             GOTO       CMDLBL(STEP4)




             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(MBDWPIA) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             SNDMSG     MSG('データ０件でした。') TOMSGQ(&WSID)
             GOTO       CMDLBL(@END)
             ENDDO

             /* AOYAMAへデータ送信*/
             SNDNETF    FILE(HWFILE1/MBDWPIA) TOUSRID((QFILE +
                          SYSTEM1))
             /* AOYAMAでデータ受信、データ付与、データ送信*/
             SBMNETJOB  FILE(HSRC1/ACLSRC) TOUSRID((QFILE SYSTEM1)) +
                          MBR(MBDTS1)

             CHGVAR     VAR(&WKAI) VALUE(0)
 STEP2:
             CHGVAR     VAR(&WKAI) VALUE(&WKAI + 1)
             DLYJOB     DLY(15)

             CHGVAR     VAR(&DFLG) VALUE(' ')
             CHKOBJ     OBJ(HWFILE1/&FILE03) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801 CPF9810) EXEC(CHGVAR +
                          VAR(&DFLG) VALUE('*'))

            IF         COND(&DFLG *NE ' ') THEN(DO)

             IF         COND(&WKAI *GE 41) THEN(DO)
STEP3:
              SNDPGMMSG  MSG('(G) NO DATA FROM AOYAMA') TOMSGQ(&WSID) +
                         MSGTYPE(*INQ) KEYVAR(&MBAN)
              RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                             MSG(&KOTAE)
              IF         COND(&KOTAE *EQ 'G') THEN(GOTO CMDLBL(@END))
              GOTO STEP3
             ENDDO
            GOTO STEP2
            ENDDO
STEP4:

             /*********************************/
             /*転送処理PC-->AS400(MBDWPIA)  */
             /*********************************/
      /* P-COM */
             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD('"C:/PROGRAM FILES/PERSONAL +
                          COMMUNICATIONS/PCSFT5.EXE" +
                          C:/ＰＴ現調化資料ＩＡＦ/TTO/MBDWPIA.TTO') +
                          PAUSE(*NO)

      /* CLIENT ACCESS */
             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD('"C:/PROGRAM FILES/IBM/CLIENT +
                          ACCESS/RTOPCB.EXE" +
                          C:/ＰＴ現調化資料ＩＡＦ/TTO/MBDWPIA.DTF') +
                          PAUSE(*NO)

 @END:
             DLTDTAARA  DTAARA(MBDCIAACT)

 @END2:      ENDPGM
