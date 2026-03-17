             PGM
             /***********************************************/
             /* SALES UNIT PRICE ESTIMATE HANDLING          */
             /*         M-OKUDA         1985.11.28          */
             /*         TCH 2000/08/02 CHANGE DEVTYP,OUTQ   */
             /*         TCH 2002/08/26 CHANGE OUTQ FORM PA TO PB */
             /***********************************************/
             DCLF       FILE(GBFPW50)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&HIZK) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TSMEI) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TNMEI) TYPE(*CHAR) LEN(8)
             DCL        VAR(&IN91) TYPE(*LGL) LEN(1)
             DCL        VAR(&IN92) TYPE(*LGL) LEN(1)
             DCL        VAR(&IN93) TYPE(*LGL) LEN(1)
             DCL        VAR(&IN94) TYPE(*LGL) LEN(1)
             DCL        VAR(&IN95) TYPE(*LGL) LEN(1)
             DCL        VAR(&IN99) TYPE(*LGL) LEN(1)
             CHGVAR     VAR(&PTKBN) VALUE('N')
             CHGVAR     VAR(&TKOJ) VALUE('*')
             /*INPUT SYSTEM VALUE WITH COMMAND                     */
             RTVJOBA    JOB(&WSNO) USER(&USER) DATE(&HIZK)
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIME)
             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)
 STEP02:     CHGJOB     OUTQ(&PRTG)
 STEP03:     SNDRCVF  DEV(&WSNO) RCDFMT(GBFPW501)
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&IN91) VALUE('0')
             CHGVAR     VAR(&IN92) VALUE('0')
             CHGVAR     VAR(&IN93) VALUE('0')
             CHGVAR     VAR(&IN94) VALUE('0')
             CHGVAR     VAR(&IN95) VALUE('0')
             IF         (&IN01 *EQ '1') GOTO END
             IF         (&TOKU *NE '    ') GOTO STEP04
             CHGVAR     VAR(&IN91) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('CUSTOMER CODE IS NOT INPUT')
             GOTO       STEP03
 STEP04:     IF         (&TKOJ *NE ' ') GOTO STEP05
             CHGVAR     VAR(&IN92) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('FACTORY CODE IS NOT INPUT')
             GOTO       STEP03
 STEP05:     IF         (&TKOJ *EQ '*') GOTO STEP18
             CHGVAR     VAR(&TSMEI) VALUE('FACTORY APPOINTMENT')
             GOTO       STEP17
 STEP18:     CHGVAR     VAR(&TSMEI) VALUE('ALL FACTORY')
 STEP17:     IF         (&START *NE '        ') GOTO STEP06
             CHGVAR     VAR(&IN93) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('CONTRACT START DATE IS NOT INPUT')
             GOTO       STEP03
 STEP06:     IF         (%SUBSTRING(&START 1 4) *LT '1984') GOTO STEP07
             IF         (%SUBSTRING(&START 5 2) *GT '12') GOTO STEP07
             IF         (%SUBSTRING(&START 7 2) *LT '01') GOTO STEP07
             IF         (%SUBSTRING(&START 7 2) *GT '31') GOTO STEP07
             IF         (%SUBSTRING(&START 7 2) *LT '01') GOTO STEP07
             GOTO       STEP08
 STEP07:     CHGVAR     VAR(&IN93) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('CONTRACT START DATE INCLUDES +
                          LOGICAL ERROR')
             GOTO       STEP03
 STEP08:     IF         (&OWARI *NE '        ') GOTO STEP09
             CHGVAR     VAR(&IN94) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('CONTRACT EXIT DATE IS NOT INPUT')
             GOTO       STEP03
 STEP09:     IF         (&OWARI  *EQ '99999999') GOTO STEP11
             IF         (%SUBSTRING(&OWARI 1 4) *LT '1984') GOTO STEP10
             IF         (%SUBSTRING(&OWARI 5 2) *GT '12') GOTO STEP10
             IF         (%SUBSTRING(&OWARI 7 2) *LT '01') GOTO STEP10
             IF         (%SUBSTRING(&OWARI 7 2) *GT '31') GOTO STEP10
             IF         (%SUBSTRING(&OWARI 7 2) *LT '01') GOTO STEP10
             GOTO       STEP11
 STEP10:     CHGVAR     VAR(&IN94) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('CONTRACT EXIT DATE INCLUDES +
                          LOGICAL ERROR')
             GOTO       STEP03
 STEP11:     IF         (&START *LE &OWARI) GOTO STEP11A
             CHGVAR     VAR(&IN93) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('CONTRACT START DATE IS +
                          LARGER THAN CONTRACT EXIT DATE')
             GOTO       STEP03
 STEP11A:    IF         (&PTKBN *EQ 'N') GOTO STEP15
             IF         (&PTKBN *EQ 'O') GOTO STEP16
 STEP12:     CHGVAR     VAR(&IN95) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('SELECT UNIT PRICE INSTRUCTION +
                          NEW=N, OLD=O')
             GOTO       STEP03
 STEP15:     CHGVAR     VAR(&TNMEI) VALUE('NEW UNIT PRICE')
             GOTO       STEP13
 STEP16:     CHGVAR     VAR(&TNMEI) VALUE('OLD UNIT PRICE')
 STEP13:     SNDRCVF  DEV(&WSNO) RCDFMT(GBFPW502)
             CHGVAR     VAR(&IN99) VALUE('0')
             IF         (&IN01 *EQ '1') GOTO END
             IF         (&IN03 *EQ '0') GOTO STEP14
             CHGVAR     VAR(&TOKU) VALUE('    ')
             CHGVAR     VAR(&TKOJ) VALUE('*')
             CHGVAR     VAR(&START) VALUE('        ')
             CHGVAR     VAR(&TSMEI) VALUE('          ')
             CHGVAR     VAR(&OWARI) VALUE('        ')
             CHGVAR     VAR(&PTKBN) VALUE('N')
             CHGVAR     VAR(&TNMEI) VALUE('        ')
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&IN91) VALUE('0')
             CHGVAR     VAR(&IN92) VALUE('0')
             CHGVAR     VAR(&IN93) VALUE('0')
             CHGVAR     VAR(&IN94) VALUE('0')
             CHGVAR     VAR(&IN95) VALUE('0')
             GOTO       STEP03
 STEP14:     IF         (&MNO *EQ 1) GOTO STEP21
             IF         (&MNO *EQ 2) GOTO STEP22
             IF         (&MNO *EQ 3) GOTO STEP23
             IF         (&MNO *EQ 4) GOTO STEP24
             IF         (&MNO *EQ 5) GOTO STEP25
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('MENU NUMBER IS NOT RIGHT')
             GOTO       STEP05
             /*INDIVIDUAL ESTIMATE CALCULATION * * * * * * * * * * * * * * * */
 STEP21:     CALL       PGM(GBFR51) PARM(&USER &TOKU &TKOJ &START +
                          &OWARI &PTKBN &TIME)
             GOTO       STEP90
             /* * * * * * INDIVIDUAL ESTIMATE CALCULATION RESULT PRINTING*/
 STEP22:
             OVRPRTF    FILE(GBFPR52) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(65) RPLUNPRT(*YES) +
                          SPOOL(*YES) OUTQ(QPRINTB) FORMTYPE(K6H1) +
                          SCHEDULE(*FILEEND)
             CALL       PGM(GBFR52) PARM(&USER &TOKU &TKOJ &START +
                          &OWARI &PTKBN &TIME)
             DLTOVR     FILE(GBFPR52)
             GOTO       STEP91
             /* * * * * * ESTIMATE AMOUNT ASSETS LIST PRINTING*/
 STEP23:
             OVRPRTF    FILE(GBFPR53) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(65) RPLUNPRT(*YES) +
                          SPOOL(*YES) OUTQ(QPRINTB) FORMTYPE(K6H1) +
                          SCHEDULE(*FILEEND)
             CALL       PGM(GBFR53) PARM(&USER &TOKU &TKOJ &START +
                          &OWARI &PTKBN)
             DLTOVR     FILE(GBFPR53)
             GOTO       STEP91
             /*******ESTIMATE CALCULATION BY BATCH *******/
 STEP24:     CHKOBJ     OBJ(GBFBACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP2))
 STP1:       SNDPGMMSG  MSG('( G ) IT IS ESTIMATE CALCULATING FOR ALL PART NO +
                        PLEASE WAIT IT TO BE END') TOMSGQ(&WSNO) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         (&KOTE *NE 'G') GOTO STP1
             GOTO       END
 STP2:       CRTDTAARA  DTAARA(HFILE1/GBFBACT) TYPE(*CHAR) LEN(6) +
                          VALUE(GBFR54) TEXT('BATCH ESTIMATE CALCULATION')
             MONMSG     MSGID(CPA0701 CPF2103)
             OVRPRTF    FILE(GBFPR54) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(65) RPLUNPRT(*YES) +
                          SPOOL(*YES) OUTQ(QPRINTB) FORMTYPE(K6H1) +
                          SCHEDULE(*FILEEND)
             CALL       PGM(GBFR54) PARM(&USER &TOKU &TKOJ &START +
                          &OWARI &PTKBN &TIME)
             DLTOVR     FILE(GBFPR54)
             IF         (&PTKBN *NE 'O') GOTO STEPB1
             /** SALES PRICE OLD UNIT PRICE IS STORED IN OTHER FILE******/
             CPYF       FROMFILE(HFILE1/GBFPP51) +
                          TOFILE(HFILE1/GBFTP52) MBROPT(*REPLACE)
 STEPB1:     DLTDTAARA  DTAARA(GBFBACT)
             GOTO       STEP91
             /****** SALES PRICE ESTIMATE PRINTING   */
 STEP25:
             OVRPRTF    FILE(GBFPR55) PAGESIZE(66 132) LPI(6) +
                          OVRFLW(66) RPLUNPRT(*YES) SPOOL(*YES) +
                          OUTQ(QPRINT) FORMTYPE(D621) +
                          SCHEDULE(*FILEEND)
             CALL       PGM(GBFR55) PARM(&USER &TOKU &TKOJ &START +
                          &OWARI &PTKBN)
             DLTOVR     FILE(GBFPR55)
             GOTO       STEP91
 STEP91:
 STEP90:     CHGVAR     VAR(&MNO) VALUE(0)
             GOTO       STEP05
 END:        ENDPGM
