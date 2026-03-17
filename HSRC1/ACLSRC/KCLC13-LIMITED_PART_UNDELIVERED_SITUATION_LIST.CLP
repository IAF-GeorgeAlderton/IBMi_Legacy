             PGM
             /** KCLC13 **************************************/
             /*LIMITED PART UNDELIVERED SITUATION LIST / BY DATE  */
             /*            K.NAKMAURA 1990.09.18             */
             /************************************** KCLC13 **/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&KOSIN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&KUBN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FH) TYPE(*CHAR) LEN(8)
             DCL        VAR(&TH) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WTEHI) TYPE(*CHAR) LEN(1)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WS) USER(&US)
             CHGVAR     VAR(&KOSIN) VALUE('N')
             CHGVAR     VAR(&WT) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(&FILE1) VALUE('KCLWP03' *CAT &WT)
             CHGVAR     VAR(&FILE2) VALUE('KCLWP04' *CAT &WT)
             CHGJOB     SWS(00000000)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
 STP1:
 /* UNDELIVERED SITUATION LIST PUBLICATION */
 /* WORK FILE CREATE KCLWP03 */
             OVRDBF     FILE(KCLWP03) TOFILE(&FILE1)
             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(610) +
                          TEXT('LIMITATION PART UNDELIVERED LIST WORKLIB') +
                          OPTION(*NOLIST) SIZE(1000 1000 3) LVLCHK(*NO)
             CALL       PGM(KCLR13) PARM(&KUBN &FH &TH &WTEHI)
             IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)
             DLTF       FILE(&FILE1)
             GOTO       CMDLBL(END)
             ENDDO
 /* WORK FILE CREATE KCLWP03 */
             OVRDBF     FILE(KCLWP04) TOFILE(&FILE2)
             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(610) +
                          TEXT('LIMITATION PART UNDELIVERED LIST WORKLIB') +
                          OPTION(*NOLIST) SIZE(1000 1000 3) LVLCHK(*NO)
             FMTDTA     INFILE((&FILE1)) OUTFILE(&FILE2) +
                          SRCFILE(FMTSRC) SRCMBR(UUUS04) +
                          OPTION(*NOPRT) /* SECTION,PART +
                          NO,PROD.    ORDER NO,LOCATION */
             OVRPRTF    FILE(KCLPR13) DEVTYPE(*AFPDS) LPI(6) +
                          OVRFLW(66) RPLUNPRT(*YES) OUTQ(QPRINTA) +
                          FORMTYPE(K6H1)  /* +
                          LIMITATION PART UNDELIVERED LIST .DATE +
                          APPOINTMENT */
             CALL       PGM(KCLR14) PARM(&US &KUBN &FH &TH &WTEHI)
             DLTF       FILE(&FILE1)
             DLTF       FILE(&FILE2)
             DLTOVR     FILE(*ALL)
 END:        ENDPGM
