             PGM
             /** AUAC41 ************************************/
             /* FILLING IN USER KANBAN CHECK SHEET   CL    */
             /*         Y-SUZUKI        1986.11.15         */
             /*----------------------------------          */
             /*   JW   2025.04.17 CHANGE PROGRAM NAME      */
             /************************** COPY FROM BUAC41 **/
             DCL        VAR(&UNONY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&UNOBI) TYPE(*CHAR) LEN(8)
             DCL        VAR(&UBIN)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&UNKOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ORDER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SWS)   TYPE(*CHAR) LEN(8) VALUE('00000000')
             DCL        VAR(&WSNO)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&US)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MBAN)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FLG)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&REC)   TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE3) TYPE(*CHAR) LEN(9)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSNO)  USER(&US)

             CHGVAR     VAR(&WS)    VALUE(%SST(&WSNO 1 2))

             CALL       PGM(AGAR01) PARM(&WSNO &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

             CHKOBJ     OBJ(AUAC41ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@STP1))
 @STP2:      SNDPGMMSG  MSG('( G )I HANDLE IT A SEPARATE TERMINAL. +
                          PLEASE WAIT FOR A WHILE.') TOMSGQ(&WSNO) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +
                          THEN(GOTO CMDLBL(@STP2))
             GOTO       END@

 @STP1:      CRTDTAARA  DTAARA(AUAC41ACT) TYPE(*CHAR) LEN(10) +
                          TEXT('DATA AREA FOR KANBAN CHECK') AUT(*ALL)

             CHGJOB     SWS(00000000)
             CHGVAR     VAR(&SWS)    VALUE('00000000')
             CHGVAR     VAR(&FILE1)  VALUE('AB#WP10' *CAT &WS)
             CHGVAR     VAR(&FILE2)  VALUE('AB#WP11' *CAT &WS)
             CHGVAR     VAR(&FILE3)  VALUE('MITANKF' *CAT &WS)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AB#WP10) TEXT('KANBAN CHECK WORK +
                          DATA 1') OPTION(*NOLIST *NOSRC) SIZE(1000 +
                          500 5) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AB#WP11) TEXT('KANBAN CHECK WORK +
                          DATA 1') OPTION(*NOLIST *NOSRC) SIZE(1000 +
                          500 5) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FILE3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE3) RCDLEN(300) +
                          TEXT('KANBAN CHECK UNUNIT PRICE DATA') +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 500 5) +
                          LVLCHK(*NO) AUT(*ALL)

             /****************************************/
             /*                             */
             /****************************************/
             CALL       PGM(AUAR41) PARM(&UNONY &UNOBI &UBIN &UNKOJ +
                          &ORDER)

             IF         (%SWITCH(0XXXXXXX)) GOTO END

             /****************************************/
             /*                      */
             /****************************************/
             OVRDBF     FILE(AB#WP10) TOFILE(&FILE1)
             CALL       PGM(AUAR43) PARM(&UNONY &UNKOJ &UNOBI &UBIN +
                          &SWS &ORDER)

             /****************************************/
             /*                     */
             /****************************************/
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(AUAR45)
             GOTO       EXE

             /****************************************/
             /*     OK OUTPUT       */
             /****************************************/
 MES:        SNDPGMMSG  MSG('( G,C ) COMPARE DATAS WHICH YOU INPUT +
                          IT AND SALSE LIST.                     +
                          EXCUTE SALES ADDING UP HANDING ----> +
                          G                                   +
                          CANCEL SALES ADDING UP HANDING ----> C') +
                          TOMSGQ(&WSNO) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *EQ 'G') *OR (&KOTAE *EQ 'g')) +
                          THEN(GOTO CMDLBL(EXE))
             IF         COND((&KOTAE *EQ 'C') *OR (&KOTAE *EQ 'c')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       MES

             /**************************************************/
             /*                               */
             /*    IT IS COMMON FROM THE FOLLOWING ROUTINE     */
             /**************************************************/
             /****************************************/
             /*                    */
             /****************************************/
 EXE:        CALL       PGM(AB#R15)

             /****************************************/
             /*                   */
             /****************************************/
             OVRDBF     FILE(AB#WP11) TOFILE(&FILE2)
             OVRDBF     FILE(MITANKF) TOFILE(&FILE3)
             CALL       PGM(AB#R10) PARM(&FLG)

             IF         (&FLG *EQ '*') DO
             /****************************************/
             /*                        */
             /****************************************/
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(AB#R11)

             SNDPGMMSG  MSG('THERE IS A UNUNIT PRICE IN THE RING TUM +
                          CHECK DATA.  THE LIST IS OUTPUT.') +
                          TOMSGQ(&WSNO)
             ENDDO

             /****************************************/
             /*                    */
             /****************************************/
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          156) LPI(6) CPI(12) OVRFLW(58) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)

  /*** (JW1) CHANGE AB#R13 TO AB#R14A             **/
  /********  CALL       PGM(AB#R13) PARM(&US)    ***/
             CALL       PGM(AB#R14A) PARM(&US)

             /****************************************/
             /*     A-PICS              */
             /****************************************/
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(AB#R14)
             DLTOVR     FILE(*ALL)

 END:        DLTDTAARA  DTAARA(AUAC41ACT)

 END@:       ENDPGM
