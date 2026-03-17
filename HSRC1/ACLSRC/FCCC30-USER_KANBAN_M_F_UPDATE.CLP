             PGM
             /** FCCC30 **************************************/
             /* ..USER KANBAN M/F UPDATE ..                  */
             /* I-HASADA 84.11.13                            */
             /* N-HYOTO  01.02.09 ADD TEST MODE              */
             /* JW1      06.29.23 DISPLAY "NOT AVALABLE"     */
             /************************************************/
             DCL        VAR(&WS)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NY)     TYPE(*CHAR) LEN(4)
             DCL        VAR(&KJ)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&UK)     TYPE(*CHAR) LEN(4)
             DCL        VAR(&SB)     TYPE(*CHAR) LEN(4)
             DCL        VAR(&HN)     TYPE(*CHAR) LEN(5)
             DCL        VAR(&U1)     TYPE(*LGL) LEN(1)
             DCL        VAR(&PYM)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&ABADS1) TYPE(*CHAR) LEN(48)
             DCL        VAR(&FILE)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&PDEVT)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)

 /** JW1 ***************************************************/
             CALL       PGM(UTLC99B) PARM('FCCC30')
             GOTO       CMDLBL(ENDP)
 /**********************************************************/

             RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)
             RTVJOBA    JOB(&WS) USER(&US)

             CHGVAR     VAR(&PYM) VALUE(%SST(&ABADS1 1 6))
             CHGVAR     VAR(&NY) VALUE('    ')
             CHGVAR     VAR(&KJ) VALUE(' ')
             CHGVAR     VAR(&UK) VALUE('    ')
             CHGVAR     VAR(&SB) VALUE('    ')
             CHGVAR     VAR(&HN) VALUE('     ')
             CHGVAR     VAR(&U1) VALUE('0')

             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&US &WLIB)

             CHKOBJ     OBJ(HFILE1/ABAACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(XTP1))

 XTP2:       SNDPGMMSG  MSG('( G ) +
                             USER PRODUCT DEMAND FORECAST DATA UPDATE HANDLING +
                             IS ACTIVE.PLEASE WAIT FOR A WHILE.+
                             < EXECUTION IS G >') TOMSGQ(&WS) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +
                          THEN(GOTO CMDLBL(XTP2))
             GOTO       ENDP

 XTP1:       CRTDTAARA  DTAARA(HFILE1/ABAACT) TYPE(*CHAR) LEN(10) +
                          TEXT('DURING USER KANBAN M/F UPDATE +
                          HANDLING') AUT(*ALL)

 /* WORK FILE CREATE */
             CHGVAR     VAR(&FILE) VALUE('ALBWPA5' *CAT (%SST(&WS 1 +
                          2)))

             DLTF       FILE(&FILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE) RCDLEN(130) +
                          OPTION(*NOLIST *NOSRC) SIZE(5000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) OVRFLW(60) +
                          OUTQ(TOPICS) FORMTYPE(K6S1) HOLD(*YES) +
                          IGCDTA(&PIGCD)
             OVRDBF     FILE(ALBWPA5) TOFILE(&FILE)
             CALL       PGM(FCCR30) PARM(&PYM &US &NY &KJ &UK &SB +
                          &HN &HN &HN &HN &U1)
             DLTOVR     FILE(*ALL)

 STP1:       CHKOBJ     OBJ(HFILE1/ALACHK) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP2))

             DLYJOB     DLY(10)
             GOTO       STP1

 STP2:       CRTDTAARA  DTAARA(HFILE1/ALACHK) TYPE(*CHAR) LEN(10) +
                          TEXT('TOPICS RECIEVE M/F DATA CREATE +
                          CHECK') AUT(*ALL)
             MONMSG     MSGID(CPF1023) EXEC(GOTO CMDLBL(STP1))

             CHKOBJ     OBJ(ALBWPA5) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&WLIB/ALBWPA5) RCDLEN(130) +
                          TEXT('TOPICS RECIEVE KANBAN M/F') +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))
             CPYF       FROMFILE(&FILE) TOFILE(ALBWPA5) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             DLTF       FILE(&FILE)

             DLTDTAARA  DTAARA(HFILE1/ABAACT)
             MONMSG     MSGID(CPF2105)

             DLTDTAARA  DTAARA(HFILE1/ALACHK)
             MONMSG     MSGID(CPF2105)

 ENDP:       ENDPGM
