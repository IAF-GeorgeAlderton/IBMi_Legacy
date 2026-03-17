             PGM
             /** AAWC12 ************************************/
             /* K LOCATION M/F ACCOUNT BOOK (TEMPORARY LOCATION)<KANJI>*/
             /*          M-OKUDA        1986.12.05         */
             /**********************************************/
             DCLF       FILE(AAWPW12)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSNO) USER(&USER)

/*           CALL       KZZR00 PARM(&WSNO &PRT &TYPE &PRTG)         */
             CALL       AGAR00 PARM(&WSNO &PRT &TYPE &PRTG)

 STEP03:     SNDRCVF    RCDFMT(AAWPW121)

             IF         (&IN01 *EQ '1')       GOTO END

             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&IN02) VALUE('0')

             IF         (&SNO *EQ '1') GOTO STEP04
             IF         (&SNO *EQ '2') GOTO STEP05

             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('A KIND OF LIST IS SELECTED +
                          BY 1 LOCATION ORDER 2 P/N ORDER')
             GOTO STEP03

 STEP04:     OVRPRTF    FILE(AAWPR11) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) OUTQ(QPRINTB) +
                          FORMTYPE(K6H1)
             CALL       PGM(AAWR12)
             DLTOVR     FILE(AAWPR11)
             CHGVAR     VAR(&SNO) VALUE(' ')
             GOTO       STEP03

 STEP05:     OVRPRTF    FILE(AAWPR12) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) OUTQ(QPRINTB) +
                          FORMTYPE(K6H1)
             CALL       PGM(AAWR13)
             DLTOVR     FILE(AAWPR12)
             CHGVAR     VAR(&SNO) VALUE(' ')
             GOTO       STEP03

 END:        ENDPGM
