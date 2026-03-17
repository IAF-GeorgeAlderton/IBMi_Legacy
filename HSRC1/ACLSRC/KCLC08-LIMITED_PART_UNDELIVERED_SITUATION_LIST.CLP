             PGM
             /** KCLC08 **************************************/
             /* LIMITED PART UNDELIVERED SITUATION LIST */
             /* A-IDOTA                 1988.01.19           */
             /************************************** KCLC08 **/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE3) TYPE(*CHAR) LEN(9)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&KOSIN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&KUBN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&KUBN2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MISU) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&WNAME) TYPE(*CHAR) LEN(16)
             RTVJOBA    JOB(&WS) USER(&US)
             CHGVAR     VAR(&KOSIN) VALUE('N')
             CHGVAR     VAR(&WT) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(&FILE1) VALUE('KCLWPA6' *CAT &WT)
             CHGVAR     VAR(&FILE2) VALUE('KCLWPB6' *CAT &WT)
             CHGVAR     VAR(&FILE3) VALUE('KCLWP04' *CAT &WT)
             CHGJOB     SWS(00000000)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

 STP1:
 /* UNDELIVERED SITUATION LIST PUBLICATION */
 /* WORK FILE CREATE KCLWPA6 */
             OVRDBF     FILE(KCLWPA6) TOFILE(&FILE1)
             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(547) +
                          TEXT('LIMITATION PART UNDELIVERED LIST WORKLIB') +
                          OPTION(*NOLIST) SIZE(1000 1000 3) LVLCHK(*NO)
 /* WORK FILE CREATE KCLWPB6 */
             OVRDBF     FILE(KCLWPB6) TOFILE(&FILE2)
             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(547) +
                          TEXT('LIMITATION PART UNDELIVERED LIST WORKLIB') +
                          OPTION(*NOLIST) SIZE(1000 1000 3) LVLCHK(*NO)

 /* DATA SELECT */
             CALL       PGM(KCLR06) PARM(&KUBN &KUBN2 &MISU)

             IF         COND(%SWITCH(00XXXXXX)) THEN(DO)
             DLTF       FILE(&FILE1)
             DLTF       FILE(&FILE2)
             GOTO       CMDLBL(END)
             ENDDO

 /*  LIMITED PART */
             IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)
 /* WORK FILE CREATE KCLWP03 */
             OVRDBF     FILE(KCLWP04) TOFILE(&FILE3)
             DLTF       FILE(&FILE3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE3) RCDLEN(547) +
                          TEXT('LIMITATION PART UNDELIVERED LIST WORKLIB') +
                          OPTION(*NOLIST) SIZE(1000 1000 3) LVLCHK(*NO)

             IF         COND(&KUBN2 *EQ '1') THEN(DO)
             FMTDTA     INFILE((&FILE1)) OUTFILE(&FILE3) +
                          SRCFILE(FMTSRC) SRCMBR(KCLS04) +
                          OPTION(*NOPRT) /* SECTION ,P/N ,SHIP ORDER,LOCATION */
             ENDDO
             ELSE       CMD(DO)
             FMTDTA     INFILE((&FILE1)) OUTFILE(&FILE3) +
                          SRCFILE(FMTSRC) SRCMBR(KCLS08) +
                          OPTION(*NOPRT) /* SECTION ,PROD. ORDER +
                          DATE ,PART NO,PROD. ORDER,LOCATION */
             ENDDO

             OVRPRTF    FILE(KCLPR04) DEVTYPE(*AFPDS) LPI(6) +
                          OVRFLW(66) RPLUNPRT(*YES) OUTQ(QPRINTA) +
                          FORMTYPE(K6H1) COPIES(&MISU) +
                           /* LIMITATION PART +
                          UNDELIVERED LIST */
             CHGVAR     VAR(&WNAME) VALUE('LIMITED PART')
             CALL       PGM(KCLR08) PARM(&US &KUBN &KUBN2 &WNAME)
             DLTOVR     FILE(KCLWP04)
             ENDDO

 /*  TRIAL MFG */
             IF         COND(%SWITCH(X1XXXXXX)) THEN(DO)
 /* WORK FILE CREATE KCLWP03 */
             OVRDBF     FILE(KCLWP04) TOFILE(&FILE3)
             DLTF       FILE(&FILE3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE3) RCDLEN(547) +
                          TEXT('LIMITATION PART UNDELIVERED LIST WORKLIB') +
                          OPTION(*NOLIST) SIZE(1000 1000 3) LVLCHK(*NO)

             IF         COND(&KUBN2 *EQ '1') THEN(DO)
             FMTDTA     INFILE((&FILE2)) OUTFILE(&FILE3) +
                          SRCFILE(FMTSRC) SRCMBR(KCLS04) +
                          OPTION(*NOPRT) /* SECTION ,PART NO ,PROD.    +
                          ORDER NO, LOCATION */
             ENDDO
             ELSE       CMD(DO)
             FMTDTA     INFILE((&FILE2)) OUTFILE(&FILE3) +
                          SRCFILE(FMTSRC) SRCMBR(KCLS08) +
                          OPTION(*NOPRT) /* SECTION ,PROD.    ORDER +
                          DATE ,PART NO,PROD.    ORDER NO,LOCATION */
             ENDDO

             OVRPRTF    FILE(KCLPR04) DEVTYPE(*AFPDS) LPI(6) +
                          OVRFLW(66) RPLUNPRT(*YES) OUTQ(QPRINTA) +
                          FORMTYPE(K6H1) COPIES(&MISU) +
                           /* LIMITATION PART +
                          UNDELIVERED LIST */
             CHGVAR     VAR(&WNAME) VALUE('TRIAL MFG')
             CALL       PGM(KCLR08) PARM(&US &KUBN &KUBN2 &WNAME)
             ENDDO

             DLTF       FILE(&FILE1)
             DLTF       FILE(&FILE2)
             DLTF       FILE(&FILE3)
             DLTOVR     FILE(*ALL)
 END:        ENDPGM
