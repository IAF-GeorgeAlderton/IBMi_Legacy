             PGM        PARM(&WSID &USER &PHS &IAFSRC &IAFFILE +
                          &IAFWFILE &PDEVT &PIGCD &PRTG)
             /** CAACJ1 ************************************/
             /*  ..Ａ－ＰＩＣＳⅡ　生産指示データ作成..  */
             /*  ..A-PICS2 PRODUCTION DATA CREATION        */
             /*  ..ＪＯＢＱ                              */
             /*       I-HASADA              93.05.24       */
             /*       MSK                   02.03.25       */
             /************************************ CAACJ1 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PHS) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WHS) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WDHS) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CHH) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&RPY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WDLYC) TYPE(*CHAR) LEN(1)
             DCL        VAR(&XTIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&XHH) TYPE(*CHAR) LEN(1)
             DCL        VAR(&XMM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PDTKN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&IAFSRC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&IAFFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&IAFWFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             DCL        VAR(&PB0111) TYPE(*CHAR) LEN(4)

             DCL        VAR(&PI0111) TYPE(*CHAR) LEN(2)
STPR:
             CHKOBJ     OBJ(CAAACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STPX))

             SNDUSRMSG  MSG('A-PICS2 PRODUCTION INSTRUCTION DATA MAKING +
                          PGM IS ACTIVE.<  RETRY -> R  CANCEL -> C  +
                          >') VALUES('R' 'C') MSGTYPE(*INQ) +
                          TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         ((&RPY *EQ 'R') *OR (&RPY *EQ 'r')) GOTO STPR
             IF         ((&RPY *EQ 'C') *OR (&RPY *EQ 'c')) GOTO @END
STPX:
             CRTDTAARA  DTAARA(HFILE1/CAAACT) TYPE(*CHAR) LEN(10) +
                          TEXT('A-PICS2 PRODUCTION-INSTRUCTION DATA +
                          CREATION') AUT(*ALL)

             CHGJOB     RUNPTY(35) SWS(00000000)
             CHGVAR     VAR(&WDLYC) VALUE(' ')

             CHGVAR     VAR(%SST(&WHS 1 4)) VALUE(&PHS)
             IF         (&PHS *NE '0000') GOTO SJGO

             /*----------------------------------------------*/
             /*  ..Ａ－ＰＩＣＳⅡ未転送データリスト出力..  */
             /*  ..Ａ－ＰＩＣＳⅡ時刻別計算便マスター      */
             /*----------------------------------------------*/
 @STP1:      OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(CAARA1) PARM(&USER)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  MSG('AN ERROR OCCURRED IN THE PROGRAM +
                          (CAARA1) .... <  RETRY -> R  CANCEL -> C  +
                          >') VALUES('R' 'C') MSGTYPE(*INQ) +
                          TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         ((&RPY *EQ 'R') *AND (&RPY *EQ 'r')) GOTO @STP1
             RETURN
             ENDDO
             DLTOVR     FILE(QPRINT)

             IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)
 XTP1:       SNDPGMMSG  MSG('''A-PICS2 TAKE BY-FACTORY UNFORWARDED +
                          LIST TO MASS PRODUCTION TEAM SUPERVISOR. +
                          THE PROGRAM WILL NOW END. PRESS ''G'' +
                          ENTER.''') TOMSGQ(QSYSOPR) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF        ((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) GOTO XTP1
             RETURN
             ENDDO

             /*------------------------------------------*/
             /*  ..Ａ－ＰＩＣＳⅡ　データシフト..      */
             /*  ..Ａ－ＰＩＣＳⅡ時刻別計算便マスター  */
             /*------------------------------------------*/
 @STP2:      CALL       PGM(CAARC1)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR AT PGM(CAARC1) +
                          < RETRY-R +
                          CABCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF        ((&RPY *EQ 'R') *AND (&RPY *EQ 'r')) GOTO @STP2
             RETURN
             ENDDO

             /*----------------------------------------------*/
             /*  ..Ａ－ＰＩＣＳⅡ未転送データリスト出力..  */
             /*  ..Ａ－ＰＩＣＳⅡ平準化確定発注ファイル    */
             /*----------------------------------------------*/
 @STP3:      OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(CAARB1) PARM(&USER)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR AT PGM(CAARB1) +
                          < RETRY-R +
                          CABCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF        ((&RPY *EQ 'R') *AND (&RPY *EQ 'r')) GOTO @STP3
             RETURN
             ENDDO
             DLTOVR     FILE(QPRINT)

             IF         COND(%SWITCH(X1XXXXXX)) THEN(DO)
             SNDPGMMSG  MSG('A-PICS2 TAKE UNFORWARDED DATA LIST TO +
                          MASS PRODUCTION TEAM SUPERVISOR') +
                          TOMSGQ(QSYSOPR)
             ENDDO

 SJGO:       CHGJOB     SWS(00000000)

             /*-----------------------------------------------------------*/
             /*  ..LEVELED FIXED ORDER-PLACEMENT CUMULATIVE FILE UPDATE.. */
             /*  .. CABWP01 (WORK) --> CABPP01 (M/F)                      */
             /*-----------------------------------------------------------*/
 @STP4:      CALL       PGM(CAARD1)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  MSG('AN ERROR OCCURRED IN THE PROGRAM +
                          (CAARD1) .... <  RETRY -> R  CANCEL -> C  +
                          >') VALUES('R' 'C') MSGTYPE(*INQ) +
                          TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         ((&RPY *EQ 'R') *AND (&RPY *EQ 'r')) GOTO @STP4
             RETURN
             ENDDO

             /*------------------------------------------*/
             /*  ..ＤＬＹＪＯＢ　（定時刻まで待つ）..  */
             /*------------------------------------------*/
             CHGVAR     VAR(%SST(&WHS 5 2)) VALUE('00')
             CHGVAR     VAR(&WDHS) VALUE(&WHS)

             IF         (&WDLYC *EQ ' ') GOTO STP1

             IF         (%SST(&WHS 1 2) *EQ '24') DO
             CHGVAR     VAR(&WDHS) VALUE('235959')
             ENDDO

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&XTIME)
             CHGVAR     VAR(&XHH) VALUE(%SST(&XTIME 1 1))
             CHGVAR     VAR(&XMM) VALUE(%SST(&XTIME 3 2))
             IF         (&WDHS *EQ '235959') DO
             IF         (&XHH *EQ '0') GOTO STP1
             IF         (&XMM *EQ '59') GOTO STP1
             ENDDO

             IF         (&XTIME *GE &WDHS) GOTO STP1

             DLYJOB     RSMTIME(&WDHS)

 STP1:       CHGVAR     VAR(&WDLYC) VALUE('*')

             IF         (%SUBSTRING(&WDHS 1 4) *EQ '2359') DO
             CHGVAR     VAR(&WDHS) VALUE('240000')
             ENDDO

             CHGVAR     VAR(&PB0111) VALUE('    ')

             CHGVAR     VAR(&PI0111) VALUE(' ')


             /*--------------------------------------------------*/
             /*  ..Ａ－ＰＩＣＳⅡ生産指示　準備有無チェック..  */
             /*--------------------------------------------------*/
 @STP5:      CALL       PGM(CAARE1) PARM(&WHS &PB0111 &PI0111)

             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR AT PGM(CAARE1) +
                          < RETRY-R +
                          CABCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         ((&RPY *EQ 'R') *AND (&RPY *EQ 'r')) GOTO @STP5
             RETURN
             ENDDO

             /*------------------------------------------*/
             /*  ..Ａ－ＰＩＣＳⅡ受注累積ファイル      */
             /*  ..Ａ－ＰＩＣＳⅡ計画発行ファイル      */
             /* CA#PP11 -> CA#PP21                                  */
             /*         -> CAAWP02 -> CAAWP22 -> CAAWP03 -> CABPP01 */
             /* CTAPP01 -> CABPP01                                  */
             /*-----------------------------------------------------*/
             CALL       PGM(CAAC02) PARM(&USER &WHS &IAFSRC &IAFFILE +
                          &IAFWFILE &PDEVT &PIGCD &PRTG)

             IF         (%SWITCH(0XXXXXXX)) DO
             GOTO       STP2
             ENDDO


             /*----------------------------------------------*/
             /*  ..Ａ－ＰＩＣＳⅡ　生産指示便データ作成..  */
             /*  ..データ編集                              */
             /*----------------------------------------------*/
 @STP6:      CHKOBJ     OBJ(CAAWP05) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTPF      FILE(&IAFWFILE/CAAWP05) +
                          SRCFILE(&IAFSRC/ADDSSRC) SRCMBR(CAAWP05) +
                          OPTION(*NOLIST *NOSRC) SIZE(3000 1000) +
                          LVLCHK(*NO) AUT(*ALL)
             ENDDO
             CLRPFM     FILE(CAAWP05)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)
             OVRPRTF    FILE(QPRINT2) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)

             /* CABPP01 <-> CADPP01   */
             /*          -> CAAWP05   */
          CALL       PGM(CAAR04) PARM(&USER &PB0111 &PI0111)

             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR AT PGM(CAAR04) +
                          < RETRY-R +
                          CABCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF        ((&RPY *EQ 'R') *AND (&RPY *EQ 'r')) GOTO @STP6
             RETURN
             ENDDO
             DLTOVR     FILE(QPRINT)
             DLTOVR     FILE(QPRINT2)

             IF         COND(%SWITCH(XX1XXXXX)) THEN(DO)
             SNDPGMMSG  MSG('A-PICS2 TAKE UNCALCULATABLE +
                          DELIVERY-TIME LIST OR PART +
                          M/F-NONEXISTENT LIST TO MASS PRODUCTION +
                          TEAM SUPERVISOR.') TOMSGQ(QSYSOPR)
             ENDDO

             /*--------------------------------------------------------*/
             /*  ..CUMULATION OF INSTRUCTION KANBAN PUBLICATION DATA.. */
             /*--------------------------------------------------------*/
             /* CAAWP05  -> CAAPP05   */
             /*  CAAPP05 IS USED BY CAAC50 */
 @STP8:      CALL       PGM(CAAR05)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR AT PGM(CAAR05) +
                          < RETRY-R +
                          CABCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF        ((&RPY *EQ 'R') *AND (&RPY *EQ 'r')) GOTO @STP8
             RETURN
             ENDDO

             /*--------------------------------------------*/
             /*  ..Ａ－ＰＩＣＳⅡ　生産指示データ作成..  */
             /*  ..時刻別計算便マスター準備完了マーク    */
             /*   UPDATE CAIPP11                           */
             /*--------------------------------------------*/
 @STP7:      CALL       PGM(CAAR06) PARM(&PB0111 &PI0111)

             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR AT PGM(CAAR06) +
                          < RETRY-R +
                          CABCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF       ((&RPY *EQ 'R') *AND (&RPY *EQ 'r')) GOTO @STP7
             RETURN
             ENDDO

             /*--------------------------------------*/
             /*  ..次のＪＯＢ実行時刻を設定する..  */
             /*--------------------------------------*/
 STP2:       CHGVAR     VAR(&CHH) VALUE(%SST(&WHS 1 2))
             CHGVAR     VAR(&CHH) VALUE(&CHH + 1)

             IF         (&CHH *GT 24) DO
             CHGVAR     VAR(&CHH) VALUE(01)
             ENDDO

             CHGVAR     VAR(%SST(&WHS 1 2)) VALUE(&CHH)
             IF         (&CHH *GT 23) GOTO SLST

             GOTO       SJGO

             /*----------------------------------------------*/
             /*  ..Ａ－ＰＩＣＳⅡ受注累積ファイル再編成..  */
             /*----------------------------------------------*/
 SLST: /*    CLRPFM     FILE(CA#NP40)  */
       /*    CALL       PGM(CAAR07)    */

       /*    CPYF       FROMFILE(CA#NP40) TOFILE(CA#PP11) +
                          MBROPT(*REPLACE) FMTOPT(*MAP)   **/
       /*    MONMSG     MSGID(CPF2817 CPF2909)       **/

             /*--------------------------------------*/
             /*  ..指示かんばん発行データ再編成..  */
             /*--------------------------------------*/
    /*       CLRPFM     FILE(CAANP08)      **/
    /*       CALL       PGM(CAAR08)        **/

    /*       CPYF       FROMFILE(CAANP08) TOFILE(CAANP05) +
                          MBROPT(*REPLACE) FMTOPT(*MAP)       **/

    /*       MONMSG     MSGID(CPF2817 CPF2909)         **/

             /*--------------------------------------------*/
             /*  ..Ａ－ＰＩＣＳⅡ未転送データチェック..  */
             /*  ..Ａ－ＰＩＣＳⅡ時刻別計算便マスター    */
             /*  ..当日分                                */
             /*--------------------------------------------*/
             CHGVAR     VAR(&PDTKN) VALUE(' ')
             CALL       PGM(CAAR09) PARM(&PDTKN)

             IF         (&PDTKN *EQ '*') DO
 SLTR:       SNDPGMMSG  MSG('UNFORWARDED KANBAN DATA IN A-PICS2 +
                          INSTRUCTION KANBANS. NOTIFY MASS +
                          PRODUCTION TEAM PROJECT MANAGER.') +
                          TOMSGQ(QSYSOPR) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF        ((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) GOTO SLTR
             ENDDO

             DLTDTAARA  DTAARA(CAAACT)
@END:
             ENDPGM
