             PGM
             /*** BTBC85 *******************************/
             /* WIRE ORDER ADJUST PLAN BATCH UPDATE    */
             /*       SHIMAZU.      2015.04.24         */
             /* JW1   2021.04.06 SAVE BTBWP85          */
             /******************************************/
             DCLF       FILE(BTBPW85)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MSGTXT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P9ER1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P9ER2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PERR) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HWFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TWFILE1  ')
             ENDDO

             CRTDTAARA  DTAARA(&WLIB/BTBC85ACT) TYPE(*CHAR) LEN(10) +
                          VALUE(&USER) AUT(*ALL)
             MONMSG     MSGID(CPF1023) EXEC(DO)
STEP0:
             SNDPGMMSG  MSG('( G ) IT IS USING IT WITH OTHER +
                          TERMINALS NOW.PLEASE TRY LATER.') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         COND(&KOTE *NE 'G') THEN(GOTO CMDLBL(STEP0))
             GOTO       CMDLBL(@END)
             ENDDO

@RUN:
@RETRY:
             DLTF       FILE(&WLIB/BTBWP85)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/BTBWP85) RCDLEN(2048) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

 @DSP01:
             SNDRCVF    DEV(&WSID) RCDFMT(BTBPW851)
             CHGVAR     VAR(&IN99) VALUE('0')
             /***************/
             /* CMD1 =終了*/
             /***************/
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@EXIT))
 @OK:
             /***************/
             /* CMD5 =実行*/
             /***************/
             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(@DSP01))

STP2:        /***********************/
             /*転送処理PC-->AS400 */
             /***********************/
             /* PC -> IAFWFILE */


STPX:        CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(BTBWP85) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('DATA IS 0.')
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       CMDLBL(@RETRY)
             ENDDO

             CLRPFM     FILE(BTBPP85)
             CLRPFM     FILE(BTBPP8Y)

             /* BTBWP85 -> BTBPP85 */
             CALL       PGM(BTBR85)

             /* CHECK DATA         */
             CALL       PGM(BTBC87) PARM(&PERR)
             IF         COND(&PERR *EQ '9') THEN(GOTO CMDLBL(@EXIT))

             EDTDTA     FILE(BTBPP85) OPT1(1) OPT2(4)

@RPRY:

             SNDPGMMSG  MSG('( G ) DATA IS OK? +
                          G:OK(UPDATE) C:NG(CALCEL)') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         COND(&KOTE *EQ 'G') THEN(GOTO CMDLBL(@EXEC))
             IF         COND(&KOTE *EQ 'C') THEN(GOTO CMDLBL(@EXIT))
             GOTO       CMDLBL(@RPRY)

@EXEC:
             DLTF       FILE(&WLIB/BTBWP86)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/BTBWP86) RCDLEN(512) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)


             CPYF       FROMFILE(BTBPP05) TOFILE(WEEKDLT/BTBPP05) +
                          MBROPT(*REPLACE) CRTFILE(*YES)

             /* BTBPP85 -> BTBPP05 */
             /* BTBPP85 -> BTBWP86 */
             CALL       PGM(BTBR86)  PARM(&P9ER1 &P9ER2)

/* JW1 SAVE BTBWP85 */
             CPYF       FROMFILE(HWFILE1/BTBWP85) +
                          TOFILE(TWFILE1/BTBWP85) MBROPT(*ADD)

             CHGVAR     VAR(&REC) VALUE(0)

             IF         COND(&P9ER1 *EQ '1') THEN(DO)
             SNDMSG     MSG('THERE WERE DATA OTHER THAN APICS.') +
                          TOMSGQ(&WSID)
             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             ENDDO

              IF         COND(&P9ER2 *EQ '1') THEN(DO)
             SNDMSG     MSG('THERE WERE DATA THAT EXCEEDED 1000.') +
                          TOMSGQ(&WSID)
              STRPCO     PCTA(*NO)
              MONMSG     MSGID(CPF0000)
              ENDDO

             RTVMBRD    FILE(BTBWP86) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)

             /* PC <- ACZWFILE */

             DLYJOB     DLY(3)

             ENDDO

@EXIT:
             DLTDTAARA  DTAARA(&WLIB/BTBC85ACT)
@END:
             ENDPGM
