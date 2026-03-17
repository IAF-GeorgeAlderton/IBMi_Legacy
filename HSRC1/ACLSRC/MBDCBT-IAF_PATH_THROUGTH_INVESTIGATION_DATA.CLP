             PGM
             /** MBDCBT *******************************************/
             /* IAF PATH THROUGTH INVESTIGATION DATA              */
             /*       MSK.......          2007.04.27              */
             /* ------------------------------------------------- */
             /* JW  2026.01.20 CHG GCLSRC --> ACLSRC              */
             /*******************************COPY FORM    MBDCAT **/
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)     TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&REC)      TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&DFLG)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&WKAI)     TYPE(*DEC) LEN(2)
             DCL        VAR(&FILE03)   TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&P1FYM)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&P1TYM)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&P1NONY)   TYPE(*CHAR) LEN(4)

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

 @GO:
             DLTF       FILE(&FILE03)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(MBDWPIA)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/MBDWPIA) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(250000 5000 4) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(MBDWPB1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/MBDWPB1) RCDLEN(0100) +
                          OPTION(*NOLIST) SIZE(250000 5000 4) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(MBDWPB2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/MBDWPB2) RCDLEN(0100) +
                          OPTION(*NOLIST) SIZE(250000 5000 4) +
                          LVLCHK(*NO) AUT(*ALL)

             CLRPFM     FILE(MBDPPB2)
             CALL       PGM(MBDRB1) PARM(&P1FYM &P1TYM &P1NONY)

             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(MBDWPB1) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             GOTO       CMDLBL(@END)
             ENDDO

             FMTDTA     INFILE((HWFILE1/MBDWPB1)) +
                          OUTFILE(HWFILE1/MBDWPB2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(MBDSB2) +
                          OPTION(*NOPRT)

             CALL       PGM(MBDRB2) PARM(&P1FYM &P1TYM &P1NONY)


             GOTO       CMDLBL(STEP4)


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
         /*  STRPCO     PCTA(*NO)                                        */
         /*  MONMSG     MSGID(CPF0000)                                   */
         /*  STRPCCMD   PCCMD('"C:/PROGRAM FILES/PERSONAL +              */
         /*               COMMUNICATIONS/PCSFT5.EXE" +                   */
         /*               C:/ＰＴ現調化資料ＩＡＦ/TTO/MBDWPIA.TTO') +  */
         /*               PAUSE(*NO)                                     */
             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD('"C:/PROGRAM FILES/IBM/CLIENT +
                          ACCESS/RTOPCB.EXE" +
                          C:/ＰＴ現調化資料ＩＡＦ/TTO/MBDWPIA.DTF') +
                          PAUSE(*NO)

 @END:
             DLTDTAARA  DTAARA(MBDCIAACT)

 @END2:      ENDPGM
