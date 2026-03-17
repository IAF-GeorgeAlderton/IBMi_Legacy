             PGM
             /** AB#C50 ************************************/
             /* SALES PROCESSINGS FROM SALES VOTES         */
             /*       CREATE DATE : JUL/10/1997.           */
             /*       AUTHOR      : S.OHTAKE.              */
             /*----------------------------------          */
             /*   JW   2025.04.17 CHANGE PROGRAM NAME      */
             /**********************************************/
             /*  VARIABLE DEFINITION   */
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&SWS)    TYPE(*CHAR) LEN(8) VALUE('00000000')
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&REC)    TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&FLG)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSNO)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             DCL        VAR(&FILE)  TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE3) TYPE(*CHAR) LEN(9)

/** JW UNUSE **/

GOTO END

/**************/


             RTVJOBA    JOB(&WSNO)  USER(&US) SWS(&SWS)

             CHGVAR     VAR(&WS)    VALUE(%SST(&WSNO 1 2))

             CALL       PGM(AGAR01) PARM(&WSNO &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

             /*  DATA ENTRY  */
 ENTRY:      CHGJOB     SWS(00000000)
             CHGVAR     VAR(&SWS)    VALUE('00000000')
             CHGVAR     VAR(&FILE)   VALUE('AB#PP50' *CAT &WS)
             CHGVAR     VAR(&FILE1)  VALUE('AB#WP10' *CAT &WS)
             CHGVAR     VAR(&FILE2)  VALUE('AB#WP11' *CAT &WS)
             CHGVAR     VAR(&FILE3)  VALUE('MITANKF' *CAT &WS)

             /******************************************/
             /* CREATE OF SALES WORKFILE(BARCODE READ) */
             /******************************************/
             DLTF       FILE(&FILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE)  SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AB#PP50) TEXT('SALES VOTES BARCODES +
                          FILE') OPTION(*NOLIST *NOSRC) SIZE(1000 +
                          500 5) LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(&FILE) OBJTYPE(*FILE) +
                          USER(*PUBLIC) AUT(*ALL)
             OVRDBF     FILE(AB#PP50) TOFILE(&FILE)
             CALL       PGM(AB#R50)

             IF         (%SUBSTRING(&SWS 1 1) *EQ '1') GOTO END

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AB#WP10) TEXT('SALES WORKFILE') +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 500 5) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(&FILE1) OBJTYPE(*FILE) +
                          USER(*PUBLIC) AUT(*ALL)

             OVRDBF     FILE(AB#WP10) TOFILE(&FILE1)
             CALL       PGM(AB#R51)

             RTVMBRD    FILE(HWFILE1/&FILE1) NBRCURRCD(&REC)
             MONMSG     MSGID(CPF3018) /* EVASION OF LOCK DURING +
                          FILE USE  */
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(END)) /* +
                          CHECK ON 0 IN FILE */

             /**************************************************/
             /*    bf ﾉ ﾓｰk] f[ gｭclc mﾞﾇ                      */
             /*    IT IS COMMON FROM THE FOLLOWING ROUTINE     */
             /**************************************************/
             /****************************************/
             /*     gｭclcﾍ]uﾇjｰ ﾉ ﾆｭcﾃﾞc             */
             /****************************************/
             CALL       PGM(AB#R15)

             /****************************************/
             /*     ﾌ]ﾌﾞbj]fuﾇjｰ ﾉ ﾆｭcﾃﾞc            */
             /****************************************/
             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AB#WP11) TEXT('SALES WORKFILE') +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 500 5) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(&FILE2) OBJTYPE(*FILE) +
                          USER(*PUBLIC) AUT(*ALL)

             DLTF       FILE(&FILE3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE3) RCDLEN(300) +
                          TEXT('KANBAN CHECK UNUNIT PRICE DATA') +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 500 5) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(&FILE3) OBJTYPE(*FILE) +
                          USER(*PUBLIC) AUT(*ALL)

             OVRDBF     FILE(AB#WP11) TOFILE(&FILE2)
             OVRDBF     FILE(MITANKF) TOFILE(&FILE3)
             CALL       PGM(AB#R52) PARM(&FLG)

             IF         COND(&FLG *NE '*') THEN(GOTO CMDLBL(STEPB))
             /***************************/
             /* UNUNIT PRICE LIST ISSUE */
             /***************************/
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(58) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(AB#R11)

 STEPA:      SNDPGMMSG  MSG('THERE IS A UNUNIT PRICE IN THE RING TUM +
                          CHECK DATA.  THE LIST IS OUTPUT.  < +
                          G-ENTER >') TOMSGQ(&WSNO) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +
                          THEN(GOTO CMDLBL(STEPA))

             /***********************************************/
             /* IT'S WRITING IN THE SALES ACCUMULATION FILE */
             /***********************************************/
 STEPB:      RTVMBRD    FILE(HWFILE1/&FILE2) NBRCURRCD(&REC)
             MONMSG     MSGID(CPF3018) /* +
                          EVASION OF LOCK DURING FILE USE  */
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(END)) /* +
                          CHECK ON 0 IN FILE */

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          156) LPI(6) CPI(12) OVRFLW(58) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)

  /*** (JW1) CHANGE AB#R13 TO AB#R14A             **/
  /********  CALL       PGM(AB#R13) PARM(&US)    ***/
             CALL       PGM(AB#R14A) PARM(&US)

 END:        DLTOVR     FILE(*ALL)

             ENDPGM
