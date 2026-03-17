             PGM
             /*** GBFCP6 ************************************/
             /* SALES UNIT PRICE ESTIMATE CONSTITUTION      */
             /* PRIMITIVE COST TOTALIZATION BY ITEM         */
             /*         M-OKUDA         1986.01.14          */
             /***********************************************/
             DCLF       FILE(GBFPW60)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PKT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&YKBN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SRKB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SW) TYPE(*CHAR) LEN(8)
             DCL        VAR(&IN90) TYPE(*LGL) LEN(1)
             DCL        VAR(&IN91) TYPE(*LGL) LEN(1)
             DCL        VAR(&IN92) TYPE(*LGL) LEN(1)
             DCL        VAR(&IN99) TYPE(*LGL) LEN(1)
             DCL        VAR(&IN02) TYPE(*LGL) LEN(1)
             CHGVAR     VAR(&PLKBN) VALUE('1')
             CHGVAR     VAR(&PTKOJ) VALUE(' ')
             /*INPUT SYSTEM VALUE WITH COMMAND                   */
             RTVJOBA    JOB(&WSNO) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)
 STEP02:     CHGJOB     OUTQ(&PRTG)
             CHKOBJ     OBJ(HFILE1/GBFACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP2))
 STP1:       SNDPGMMSG  MSG('( G ) IT IS TOTALIZING ESTIMATE +
                         COMPONENTS BY ITEM.  PLEASE WAIT UNTIL IT +
                         IS TO BE END') TOMSGQ(&WSNO) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         (&KOTE *NE 'G') GOTO STP1
             GOTO       ENDEND
 STP2:       CRTDTAARA  DTAARA(HFILE1/GBFACT) TYPE(*CHAR) LEN(6) +
                          VALUE(GBFCP6) TEXT('ESTIMATE PRIMITIVE COST +
                           TOTALIZATION')
 STEP03:     SNDRCVF    DEV(&WSNO) RCDFMT(GBFPW601)
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&IN90) VALUE('0')
             CHGVAR     VAR(&IN91) VALUE('0')
             CHGVAR     VAR(&IN92) VALUE('0')
             IF         (&IN01 *EQ '1') GOTO END
             IF         (&PTOKU *NE '    ') GOTO STEP04
             CHGVAR     VAR(&IN90) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('CUSTOMER CODE IS NOT INPUT')
             GOTO       STEP03
 STEP04:     IF         (&PLKBN *EQ '1') GOTO STEP31
             IF         (&PLKBN *EQ '2') GOTO STEP32
             IF         (&PLKBN *EQ '3') GOTO STEP33
             CHGVAR     VAR(&IN91) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('SELECTION NUMBER FOR TOTALIZATION +
                         FORM IS NOT RIGHT')
             GOTO       STEP03
 STEP31:     CHGVAR     VAR(&PLMEI) VALUE('IT TOTALIZED ONLY APPOINTED FACTORY')
             GOTO       STEP05
 STEP32:     CHGVAR     VAR(&PLMEI) VALUE('TOTALIZE  ALL FACTORY BY FACTORY')
             GOTO       STEP05
 STEP33:     CHGVAR     VAR(&PLMEI) VALUE('TOTALIZE ALL FACTORY')
             GOTO       STEP05
 STEP05:     IF         (&IN02 *EQ '1') GOTO STEP06
             IF         (&PLKBN *EQ '1') CHGVAR VAR(&IN02) VALUE('1')
             IF         (&IN02 *EQ '1') GOTO STEP03
             CHGVAR     VAR(&PTKOJ) VALUE('*')
             GOTO       STEP07
 STEP06:     IF         (&PTKOJ *NE ' ') GOTO STEP07
             CHGVAR     VAR(&IN92) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('FACTORY CODE IS NOT INPUT')
             GOTO       STEP03
 STEP07:     SNDRCVF  DEV(&WSNO) RCDFMT(GBFPW602)
             CHGVAR     VAR(&IN99) VALUE('0')
             IF         (&IN01 *EQ '1') GOTO END
             IF         (&IN03 *EQ '0') GOTO STEP08
             CHGVAR     VAR(&PTOKU) VALUE('    ')
             CHGVAR     VAR(&PTKOJ) VALUE(' ')
             CHGVAR     VAR(&PLKBN) VALUE(' ')
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&IN90) VALUE('0')
             CHGVAR     VAR(&IN91) VALUE('0')
             CHGVAR     VAR(&IN92) VALUE('0')
             CHGVAR     VAR(&IN02) VALUE('0')
             GOTO       STEP03
 STEP08:     IF         (&MNO *GE 1) IF (&MNO *LE 6) GOTO STEP09
 STEP10:     CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('MENU NUMBER IS NOT RIGHT')
             GOTO       STEP07
 STEP09:     IF         (&MNO *EQ 1) GOTO STEP11
             IF         (&MNO *EQ 2) GOTO STEP12
             IF         (&MNO *EQ 3) GOTO STEP13
             IF         (&MNO *EQ 4) GOTO STEP14
             IF         (&MNO *EQ 5) GOTO STEP15
             IF         (&MNO *EQ 6) GOTO STEP16
             GOTO       STEP10
 STEP11:
             CLRPFM     FILE(GBFWP61)
             CALL       PGM(GBFR61) PARM(&PTOKU &PLKBN &PTKOJ)
             CALL       PGM(GBFR62) PARM(&PTOKU &PLKBN &PTKOJ)
             OVRPRTF    FILE(GBFPR63) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(66) RPLUNPRT(*YES) +
                          SPOOL(*YES) OUTQ(QPRINTB) FORMTYPE(K6H1) +
                          SCHEDULE(*FILEEND)
             CALL       PGM(GBFR63) PARM(&PTOKU &PLKBN &PTKOJ)
             DLTOVR     FILE(GBFPR63)
             GOTO       STEP19
 STEP12:
             CLRPFM     FILE(GBFWP66)
             CALL       PGM(GBFR66) PARM(&PTOKU &PLKBN &PTKOJ)
             CALL       PGM(GBFR67) PARM(&PTOKU &PLKBN &PTKOJ)
             OVRPRTF    FILE(GBFPR68) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(66) RPLUNPRT(*YES) +
                          SPOOL(*YES) OUTQ(QPRINTB) FORMTYPE(K6H1) +
                          SCHEDULE(*FILEEND)
             CALL       PGM(GBFR68) PARM(&PTOKU &PLKBN &PTKOJ)
             DLTOVR     FILE(GBFPR68)
             GOTO       STEP19
 STEP13:
             CLRPFM     FILE(GBFWP71)
             CHGJOB     SWS(00000000)
             CALL       PGM(GBFR71) PARM(&PTOKU &PLKBN &PTKOJ &YKBN +
                          &SRKB)
             IF         (%SUBSTRING(&SW 1 1) *EQ '1') GOTO STEP19
             OVRPRTF    FILE(GBFPR72) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(66) RPLUNPRT(*YES) +
                          SPOOL(*YES) OUTQ(QPRINTB) FORMTYPE(K6H1) +
                          SCHEDULE(*FILEEND)
             CALL       PGM(GBFR72) PARM(&PTOKU &PLKBN &PTKOJ &YKBN +
                          &SRKB)
             DLTOVR     FILE(GBFPR72)
             GOTO       STEP19
 STEP14:
             CLRPFM     FILE(GBFWP76)
             CHGJOB     SWS(00000000)
             CALL       PGM(GBFR76) PARM(&PTOKU &PLKBN &PTKOJ &PKT)
             RTVJOBA    SWS(&SW)
             IF         (%SUBSTRING(&SW 1 1) *EQ '1') GOTO STEP19
             OVRPRTF    FILE(GBFPR77) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(66) RPLUNPRT(*YES) +
                          SPOOL(*YES) OUTQ(QPRINTB) FORMTYPE(K6H1) +
                          SCHEDULE(*FILEEND)
             CALL       PGM(GBFR77) PARM(&PTOKU &PLKBN &PTKOJ &PKT)
             DLTOVR     FILE(GBFPR77)
             GOTO       STEP19
 STEP15:
             CLRPFM     FILE(GBFWP81)
             CALL       PGM(GBFR81) PARM(&PTOKU &PLKBN &PTKOJ)
             CALL       PGM(GBFR82) PARM(&PTOKU &PLKBN &PTKOJ)
             OVRPRTF    FILE(GBFPR83) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(66) RPLUNPRT(*YES) +
                          SPOOL(*YES) OUTQ(QPRINTB) FORMTYPE(K6H1) +
                          SCHEDULE(*FILEEND)
             CALL       PGM(GBFR83) PARM(&PTOKU &PLKBN &PTKOJ)
             DLTOVR     FILE(GBFPR83)
             GOTO       STEP19
 STEP16:
             CLRPFM     FILE(GBFWP86)
             CHGJOB     SWS(00000000)
             CALL       PGM(GBFR86) PARM(&PTOKU &PTKOJ &SRKB)
             RTVJOBA    SWS(&SW)
             IF         (%SUBSTRING(&SW 1 1) *EQ '1') GOTO STEP19
             OVRPRTF    FILE(GBFPR87) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(66) RPLUNPRT(*YES) +
                          SPOOL(*YES) OUTQ(QPRINTB) FORMTYPE(K6H1) +
                          SCHEDULE(*FILEEND)
             CALL       PGM(GBFR87) PARM(&PTOKU &PTKOJ &SRKB)
             DLTOVR     FILE(GBFPR87)
             GOTO       STEP19
 STEP19:
 STEP20:     CHGVAR     VAR(&MNO) VALUE(0)
             GOTO       STEP07
 END:        DLTDTAARA  DTAARA(HFILE1/GBFACT)
 ENDEND:     ENDPGM
