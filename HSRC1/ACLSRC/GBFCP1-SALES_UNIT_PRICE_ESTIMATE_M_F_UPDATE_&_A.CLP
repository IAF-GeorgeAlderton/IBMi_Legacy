             PGM
             /***********************************************/
             /* SALES UNIT PRICE ESTIMATE M/F UPDATE & ACCOUNT BOOK */
             /*         M-OKUDA         1985.11.13          */
             /***********************************************/
             DCLF       FILE(GBFPW10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&HIZK) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&IN90) TYPE(*LGL) LEN(1)
             DCL        VAR(&IN91) TYPE(*LGL) LEN(1)
             DCL        VAR(&IN92) TYPE(*LGL) LEN(1)
             DCL        VAR(&IN93) TYPE(*LGL) LEN(1)
             DCL        VAR(&IN99) TYPE(*LGL) LEN(1)
             CHGVAR     VAR(&YNO) VALUE('K6H1')
             CHGVAR     VAR(&PTKOJ) VALUE('*')
             /* INPUT SYSTEM VALUE WITH COMMAND                    */
             RTVJOBA    JOB(&WSNO) USER(&USER) DATE(&HIZK)
             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)
 STEP02:     CHGJOB     OUTQ(&PRTG)
 STEP03:     SNDRCVF  DEV(&WSNO) RCDFMT(GBFPW101)
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&IN90) VALUE('0')
             CHGVAR     VAR(&IN91) VALUE('0')
             IF         (&IN01 *EQ '1') GOTO END
             IF         (&PTOKU *NE '    ') GOTO STEP04
             CHGVAR     VAR(&IN90) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('CUSTOMER CODE IS NOT INPUT')
             GOTO       STEP03
 STEP04:     IF         (&PTKOJ *NE ' ') GOTO STEP05
             CHGVAR     VAR(&IN91) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('FACTORY CODE  IS NOT INPUT')
             GOTO       STEP03
 STEP05:     SNDRCVF  DEV(&WSNO) RCDFMT(GBFPW102)
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&IN92) VALUE('0')
             CHGVAR     VAR(&IN93) VALUE('0')
             IF         (&IN01 *EQ '1') GOTO END
             IF         (&IN03 *EQ '0') GOTO STEP06
             CHGVAR     VAR(&PTOKU) VALUE('    ')
             CHGVAR     VAR(&PTKOJ) VALUE(' ')
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&IN90) VALUE('0')
             CHGVAR     VAR(&IN91) VALUE('0')
             GOTO       STEP03
 STEP06:     IF         (&MNO *GE '1') IF (&MNO *LE '8') GOTO STEP07
 STEP21:     CHGVAR     VAR(&IN92) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('MENU NUMBER IS NOT RIGHT')
             GOTO       STEP05
 STEP07:     IF         (&MNO *LE '4') GOTO STEP08
             IF         (&YNO *EQ 'K6H1') GOTO STEP09
             IF         (&YNO *EQ 'K6H2') GOTO STEP09
             IF         (&YNO *EQ 'K6H3') GOTO STEP09
 STEP10:     CHGVAR     VAR(&IN93) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('LIST NUMBER IS NOT RIGHT')
             GOTO       STEP05
 STEP08:     IF         (&MNO *EQ '1') GOTO STEP11
             IF         (&MNO *EQ '2') GOTO STEP12
             IF         (&MNO *EQ '3') GOTO STEP13
             IF         (&MNO *EQ '4') GOTO STEP14
 STEP09:     IF         (&MNO *EQ '5') GOTO STEP15
             IF         (&MNO *EQ '6') GOTO STEP16
             IF         (&MNO *EQ '7') GOTO STEP17
             IF         (&MNO *EQ '8') GOTO STEP18
             GOTO       STEP21
 STEP11:     CALL       PGM(GBFR11) PARM(&USER &PTOKU &PTKOJ)
             GOTO       STEP20
 STEP12:     CALL       PGM(GBFR21) PARM(&USER &PTOKU &PTKOJ)
             GOTO       STEP20
 STEP13:     CALL       PGM(GBFR31) PARM(&USER &PTOKU &PTKOJ)
             GOTO       STEP20
 STEP14:     CALL       PGM(GBFR41) PARM(&USER &PTOKU &PTKOJ)
             GOTO       STEP20
 STEP15:
             OVRPRTF    FILE(GBFPR12) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(62) RPLUNPRT(*YES) +
                          SPOOL(*YES) OUTQ(QPRINTB) FORMTYPE(&YNO) +
                          SCHEDULE(*FILEEND)
             CALL       PGM(GBFR12) PARM(&USER &PTOKU &PTKOJ)
             DLTOVR     FILE(GBFPR12)
             GOTO       STEP19
 STEP16:
             OVRPRTF    FILE(GBFPR22) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(62) RPLUNPRT(*YES) +
                          SPOOL(*YES) OUTQ(QPRINTB) FORMTYPE(&YNO) +
                          SCHEDULE(*FILEEND)
             CALL       PGM(GBFR22) PARM(&USER &PTOKU &PTKOJ)
             DLTOVR     FILE(GBFPR22)
             GOTO       STEP19
 STEP17:
             OVRPRTF    FILE(GBFPR32) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(62) RPLUNPRT(*YES) +
                          SPOOL(*YES) OUTQ(QPRINTB) FORMTYPE(&YNO) +
                          SCHEDULE(*FILEEND)
             CALL       PGM(GBFR32) PARM(&USER &PTOKU &PTKOJ)
             DLTOVR     FILE(GBFPR32)
             GOTO       STEP19
 STEP18:
             OVRPRTF    FILE(GBFPR42) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(62) RPLUNPRT(*YES) +
                          SPOOL(*YES) OUTQ(QPRINTB) FORMTYPE(&YNO) +
                          SCHEDULE(*FILEEND)
             CALL       PGM(GBFR42) PARM(&USER &PTOKU &PTKOJ)
             DLTOVR     FILE(GBFPR42)
             GOTO       STEP19
 STEP19:
 STEP20:     CHGVAR     VAR(&MNO) VALUE(' ')
             CHGVAR     VAR(&YNO) VALUE('K6H1')
             GOTO       STEP05
 END:        ENDPGM
