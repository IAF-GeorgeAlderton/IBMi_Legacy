             PGM
             /*** MFBC03 *****************************/
             /* WORKING DAILY REPORT DATA TOTALIZATION CREATE */
             /* A.IDOTA 1993.02.04 */
             /***************************** MFBC03 ***/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL     VAR(&KBN) TYPE(*CHAR) LEN(1) /* PUBLICATION INSTRUCTION */
             DCL        VAR(&HIZU) TYPE(*CHAR) LEN(8) /* PUBLICATION DATE */
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9) /* WORK FILE1 */
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9) /* WORK FILE2 */
             DCL        VAR(&FILE3) TYPE(*CHAR) LEN(9) /* WORK FILE3 */
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSNO) USER(&USER)
             CHGVAR     VAR(&WT) VALUE(%SST(&WSNO 1 2))
             CHGVAR     VAR(&FILE1) VALUE('MFBWP13' *CAT &WT)
             CHGVAR     VAR(&FILE2) VALUE('MFBWP14' *CAT &WT)
             CHGVAR     VAR(&FILE3) VALUE('MFBWP15' *CAT &WT)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSNO &PDEVT &PIGCD)

/* SCREEN APPOINTMENT */
             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(20000 5000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MFBWP13) TOFILE(&FILE1)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(MFBR13) PARM(&KBN &HIZU)
             DLTOVR     FILE(*ALL)

             IF         COND(%SWITCH(00000000)) THEN(DO)
             DLTF       FILE(&FILE1)
             GOTO       CMDLBL(END)
             ENDDO

/*BY COST CENTER */
             IF         COND(&KBN *EQ '1') THEN(DO)
             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(20000 5000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) SRCFILE(FMTSRC) +
                          SRCMBR(MFBS14) OPTION(*NOPRT)

             OVRDBF     FILE(MFBWP14) TOFILE(&FILE2)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(*N +
                          156) CPI(12) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(MFBR14) PARM(&KBN &HIZU)
             DLTOVR     FILE(*ALL)

             DLTF       FILE(&FILE1)
             DLTF       FILE(&FILE2)
             ENDDO

 /*BY SHIFT */
             IF         COND(&KBN *EQ '2') THEN(DO)
             DLTF       FILE(&FILE3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE3) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(20000 5000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE3) SRCFILE(FMTSRC) +
                          SRCMBR(MFBS15) OPTION(*NOPRT)

             OVRDBF     FILE(MFBWP15) TOFILE(&FILE3)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(*N +
                          156) CPI(12) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(MFBR15) PARM(&KBN &HIZU)
             DLTOVR     FILE(*ALL)

             DLTF       FILE(&FILE1)
             DLTF       FILE(&FILE3)
             ENDDO

 END:        ENDPGM
