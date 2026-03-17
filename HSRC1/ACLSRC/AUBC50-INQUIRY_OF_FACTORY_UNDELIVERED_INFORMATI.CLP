             PGM
             /** AUBC50 ************************************/
             /* INQUIRY OF FACTORY UNDELIVERED INFORMATION */
             /*             M S K 87.03.17 */
             /**********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&IN03) TYPE(*LGL) LEN(1)
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSNO) USER(&USER)
             CHGVAR     VAR(&WT) VALUE(%SST(&WSNO 1 2))
             CHGVAR     VAR(&FILE1) VALUE('AUBWP51' *CAT &WT)
             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)
 STEP02:     CHGJOB     OUTQ(&PRTG)
LOOP:        CHGVAR     VAR(&PARM1) VALUE(' ')
             CHGVAR     VAR(&PARM2) VALUE(' ')
             CALL       PGM(AUBR50) PARM(&PARM1)
             IF         COND(&PARM1 *EQ '9') THEN(GOTO CMDLBL(END))
             IF         COND(&PARM1 *EQ '1') THEN(DO)
 AUBR51:     OVRPRTF    FILE(AUBPR51) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(64) OUTQ(QPRINTA) +
                          HOLD(*NO)
             CALL       PGM(AUBR51) PARM(&USER &PARM2 &WSNO)
                   IF (&PARM2 *EQ '3') GOTO LOOP
                   GOTO END
             ENDDO
             IF         COND(&PARM1 *EQ '2') THEN(DO)
 AUBR52:     OVRPRTF    FILE(AUBPR52) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(64) OUTQ(QPRINTA) +
                          HOLD(*NO)
             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AUBWP51) OPTION(*NOLIST *NOSRC) +
                          SIZE(100 100) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AUBWP51) TOFILE(&FILE1)
             CALL       PGM(AUBR52) PARM(&USER &PARM2 &WSNO)
        /* DLTF FILE(&FILE1) */
             DLTOVR     FILE(AUBWP51)
                   IF (&PARM2 *EQ '3') GOTO LOOP
                   GOTO END
             ENDDO
             IF         COND(&PARM1 *EQ '3') THEN(DO)
 AUBR53:     OVRPRTF    FILE(AUBPR53) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(64) OUTQ(QPRINTA)
             CALL       PGM(AUBR53) PARM(&USER &PARM2)
             IF         COND(&PARM2 *EQ '3') THEN(GOTO CMDLBL(LOOP))
                   GOTO END
             ENDDO
             IF         COND(&PARM1 *EQ '4') THEN(DO)
 AUBR54:     OVRPRTF    FILE(AUBPR54) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(64) OUTQ(QPRINTA)
             CALL       PGM(AUBR54) PARM(&USER &PARM2)
                   IF (&PARM2 *EQ '3') GOTO LOOP
                   GOTO END
             ENDDO
             IF (&PARM1 *EQ '5')  DO
 AUBR55:     OVRPRTF    FILE(AUBPR55) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(64) OUTQ(QPRINTA)
             CALL       PGM(AUBR55) PARM(&USER &PARM2)
                   IF (&PARM2 *EQ '3') GOTO LOOP
                   GOTO END
             ENDDO
             IF (&PARM1 *EQ '6')  DO
 AUBR56:     OVRPRTF    FILE(AUBPR56) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(64) OUTQ(QPRINTA)
             CALL       PGM(AUBR56) PARM(&USER &PARM2)
                   IF (&PARM2 *EQ '3') GOTO LOOP
                   GOTO END
             ENDDO
             IF (&PARM1 *EQ '7')  DO
 AUBR57:     OVRPRTF    FILE(AUBPR57) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(64) OUTQ(QPRINTA)
             CALL       PGM(AUBR57) PARM(&USER &PARM2)
                   IF (&PARM2 *EQ '3') GOTO LOOP
                   GOTO END
             ENDDO
 END:        CHGJOB     OUTQ(&PRT)
             DLTOVR     FILE(*ALL)
             ENDPGM
