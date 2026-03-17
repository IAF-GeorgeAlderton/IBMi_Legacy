             PGM
             /*** BTAC60 *********************************/
             /* P/T    PLAN PUBLICATION M/F    LIST      */
             /* T.SAKASHITA 2004.07.28                   */
             /********************************** BTAC60 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PSYSTEM) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PSYS) TYPE(*CHAR) LEN(3)

             DCL        VAR(&PCMD)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&PSTDT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PEDST) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PCFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PTFLG) TYPE(*CHAR) LEN(1)

             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)

             DCL        VAR(&MBAN)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)  TYPE(*CHAR) LEN(2)

             DCL        VAR(&DFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WKAI) TYPE(*DEC) LEN(2)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)

             DCL        VAR(&FILE01) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE02) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE03) TYPE(*CHAR) LEN(10)

             DCL        VAR(&CMD) TYPE(*CHAR) LEN(75)

             RTVJOBA    JOB(&WSID) USER(&USER)
             RTVNETA    SYSNAME(&PSYSTEM)

             CHGVAR     VAR(&PSYS) VALUE(%SST(&PSYSTEM 1 3))
             CHGVAR     VAR(&FILE01) VALUE('BTAWP60' *CAT &PSYS)
             CHGVAR     VAR(&FILE02) VALUE('BTAWP61' *CAT &PSYS)
             CHGVAR     VAR(&FILE03) VALUE('BTAWP62' *CAT &PSYS)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGJOB     OUTQ(&PRTG)

             CHKOBJ     OBJ(&WLIB/BTAC60ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@RUN))

STEP0:
             SNDPGMMSG  MSG('( G ) THIS PROCESSING IS BEING +
                          PROCESSED WITH OTHER COMPUTERS.') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         COND(&KOTE *NE 'G') THEN(GOTO CMDLBL(STEP0))
             GOTO       CMDLBL(@END2)

@RUN:
             CRTDTAARA  DTAARA(&WLIB/BTAC60ACT) TYPE(*CHAR) LEN(10) +
                          VALUE(&USER) AUT(*ALL)

             DLTF       FILE(&FILE01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE01) RCDLEN(512) +
                          OPTION(*NOSRC *NOLIST) SIZE(30000 10000 +
                          3) LVLCHK(*NO) AUT(*ALL)
             DLTF       FILE(&FILE02)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE02) RCDLEN(512) +
                          OPTION(*NOSRC *NOLIST) SIZE(30000 10000 +
                          3) LVLCHK(*NO) AUT(*ALL)
             DLTF       FILE(&FILE03)
             MONMSG     MSGID(CPF3261 CPF2105)
             OVRDBF     FILE(BTAWP60) TOFILE(&FILE01)
             CALL       PGM(BTAR60) PARM(&PCMD &PSTDT &PEDST &PCFLG +
                          &PTFLG)
             /*------*/
             /*終了*/
             /*------*/
             IF         COND(&PCMD *EQ '01') THEN(GOTO CMDLBL(@END))

             /*------------*/
             /*全品番指定*/
             /*------------*/
             IF         COND(&PCMD *EQ 'AL') THEN(DO)
             CALL       PGM(BTAR62) PARM(&PCMD &PSTDT &PEDST &PCFLG +
                          &PTFLG)
             ENDDO

             RTVMBRD    FILE(&FILE01) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
STEP1:
             SNDPGMMSG  MSG('(G) NO DATA') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
                 RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                              MSG(&KOTE)
                 IF         COND(&KOTE *EQ 'G') THEN(GOTO CMDLBL(@END))
                 GOTO STEP1
             ENDDO

             /*--------------*/
             /*海外情報付与*/
             /*--------------*/
             OVRDBF     FILE(BTAWP61) TOFILE(&FILE02)
             CALL       PGM(BTAR61) PARM(&PSYSTEM)

             /*------------*/
             /*データ送信*/
             /*------------*/
             RTVMBRD    FILE(&FILE02) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)
             SNDNETF    FILE(&WLIB/&FILE02) TOUSRID((QFILE SYSTEM1))

             OVRDBF     FILE(BTAT60) TOFILE(HSRC1/ACLSRC) MBR(BTAT60)
             CALL       PGM(BTAR63) PARM(&FILE02 &PSYS)
             SBMNETJOB  FILE(HSRC1/ACLSRC) TOUSRID((QFILE SYSTEM1)) +
                          MBR(BTAT60)
             ENDDO

             /*--------------*/
             /* BTAWP62待機*/
             /*--------------*/
             IF         COND(&PCFLG *NE 'Y') THEN(GOTO CMDLBL(@END))
             CHGVAR     VAR(&WKAI) VALUE(0)
STEP2:
             CHGVAR     VAR(&DFLG) VALUE(' ')
             CHGVAR     VAR(&WKAI) VALUE(&WKAI + 1)

             DLYJOB     DLY(15)

             CHKOBJ     OBJ(&WLIB/&FILE03) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801 CPF9810) EXEC(CHGVAR +
                          VAR(&DFLG) VALUE('*'))

            IF         COND(&DFLG *NE ' ') THEN(DO)

             IF         COND(&WKAI *GE 10) THEN(DO)
STEP3:
              SNDPGMMSG  MSG('(G) NO DATA FROM AOYAMA') TOMSGQ(&WSID) +
                         MSGTYPE(*INQ) KEYVAR(&MBAN)
              RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                             MSG(&KOTE)
              IF         COND(&KOTE *EQ 'G') THEN(GOTO CMDLBL(@END))
              GOTO STEP3
             ENDDO
                 GOTO STEP2
            ENDDO

             /*-------------*/
             /* データ転送*/
             /*-------------*/
             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&CMD) VALUE('"C:/PROGRAM FILES/PERSONAL +
                          COMMUNICATIONS/PCSFT5.EXE" +
                          C:/TTO/BTAWP72???.TTO')
             CHGVAR     VAR(&PSYS) VALUE(%SST(&PSYSTEM 1 3))
             CHGVAR     VAR(%SST(&CMD 69 3)) VALUE(&PSYS)
             STRPCCMD   PCCMD(&CMD) PAUSE(*NO)
@END:
             DLTDTAARA  DTAARA(&WLIB/BTAC60ACT)

@END2:       ENDPGM
