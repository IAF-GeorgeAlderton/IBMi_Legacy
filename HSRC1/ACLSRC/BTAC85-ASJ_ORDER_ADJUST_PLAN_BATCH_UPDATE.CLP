             PGM
             /*** BTAC80 *******************************/
             /* ASJ ORDER ADJUST PLAN BATCH UPDATE   */
             /* 計画発行データ更新処理（ＥＸＣＥＬ） */
             /*         A.MAMIYA    2005.02.21         */
             /*         T.SAKASHITA 2009.06.03         */
             /* JW1   2021.04.06 SAVE BTAWP85          */
             /******************************************/
             DCLF       FILE(BTAPW85)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&SYSTEM) TYPE(*CHAR) LEN(8)
             DCL        VAR(&P9ER1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P9ER2) TYPE(*CHAR) LEN(1)

             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACZFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACZSRC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&IPGMN) TYPE(*CHAR) LEN(10) +
                          VALUE('BTAC85    ')
             DCL        VAR(&OSTTS) TYPE(*CHAR) LEN(1)

             RTVJOBA    USER(&PPUSER)

             RTVJOBA    JOB(&WSID) USER(&USER)
             RTVNETA    SYSNAME(&SYSTEM)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)


           CHGVAR     VAR(&FLIB) VALUE('HWFILE1  ')
           CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
           IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
           CHGVAR     VAR(&FLIB) VALUE('TWFILE1 ')
           ENDDO


        /*   CHKOBJ     OBJ(&ACZFILE/BTAC85ACT) OBJTYPE(*DTAARA)  */
        /*   MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@RUN))    */

STEP0:
       /*    SNDPGMMSG  MSG('( G ) IT IS USING IT WITH OTHER +        */
       /*                 TERMINALS NOW.PLEASE TRY LATER.') +         */
       /*                 TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)   */
       /*    RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +      */
       /*                 MSG(&KOTE)                                  */
       /*    IF         COND(&KOTE *NE 'G') THEN(GOTO CMDLBL(STEP0))  */
       /*    GOTO       CMDLBL(@END)                                  */

@RUN:
        /*   CRTDTAARA  DTAARA(&ACZFILE/BTAC85ACT) TYPE(*CHAR) LEN(10)  +  */
        /*                VALUE(&USER) AUT(*ALL)                           */
@RETRY:
             DLTF       FILE(&FLIB/BTAWP85)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&FLIB/BTAWP85) RCDLEN(2048) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

 @DSP01:
             SNDRCVF    DEV(&WSID) RCDFMT(BTAPW851)
             CHGVAR     VAR(&IN99) VALUE('0')
             /***************/
             /* CMD1 = END  */
             /***************/
             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@EXIT))
 @OK:
             /***************/
             /* CMD5 =  RUN */
             /***************/
             IF         COND( IN05 *EQ '0') THEN(GOTO CMDLBL(@DSP01))

STP2:        /**********************************/
             /* TRANSFER DATA FROM PC--> AS400 */
             /**********************************/
             /* PC -> ACZWFILE */


 STPX:       DLYJOB     DLY(3)

             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(BTAWP85) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('DATA IS 0.')
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       CMDLBL(@RETRY)
             ENDDO

             CLRPFM     FILE(BTAPP85)
             CLRPFM     FILE(BTAPP8Y)

             /* BTAWP85 -> BTAPP85 */
             CALL       PGM(BTAR85)

             EDTDTA     FILE(BTAPP85) OPT1(1) OPT2(4)

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
             DLTF       FILE(&FLIB/BTAWP86)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&FLIB/BTAWP86) RCDLEN(512) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             CPYF       FROMFILE(BTAPP05) TOFILE(MAMIYA/BTAPP05) +
                          MBROPT(*REPLACE) CRTFILE(*YES)


             /* BTAPP85 -> BTAPP05 */
             /* BTAPP85 -> BTAWP86 */
             CALL       PGM(BTAR86)  PARM(&P9ER1 &P9ER2)

/* JW1 SAVE BTAWP85 */
             CPYF       FROMFILE(HWFILE1/BTAWP85) +
                          TOFILE(TWFILE1/BTAWP85) MBROPT(*ADD)

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

             RTVMBRD    FILE(BTAWP86) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)

             /* PC <- ACZWFILE */


             DLYJOB     DLY(3)

             ENDDO

@EXIT:
@END:
             ENDPGM
