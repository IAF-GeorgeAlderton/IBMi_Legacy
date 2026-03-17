             PGM
             /*** MFBC04 *****************************/
             /* WORKING DAILY REPORT DATA TOTALIZATION (CONDITION APPOINTED) */
             /* A.IDOTA               1989.11.16     */
             /***************************** MFBC04 ***/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KJYU) TYPE(*CHAR) LEN(4) /* FACTORY */
             DCL        VAR(&HIZ1) TYPE(*CHAR) LEN(8) /* PERIOD 1 */
             DCL        VAR(&HIZ2) TYPE(*CHAR) LEN(8) /* PERIOD 2 */
             DCL        VAR(&SYUR) TYPE(*CHAR) LEN(1) /* TOTALIZATION KIND */
             DCL        VAR(&KIB1) TYPE(*CHAR) LEN(3) /* MACHINE NO 1 */
             DCL        VAR(&KIB2) TYPE(*CHAR) LEN(1) /* MACHINE NO 2 */
             DCL        VAR(&COS1) TYPE(*CHAR) LEN(2) /* COST CENTER 1 */
             DCL        VAR(&COS2) TYPE(*CHAR) LEN(2) /* COST CENTER 2 */
             DCL        VAR(&COS3) TYPE(*CHAR) LEN(2) /* COST CENTER 3 */
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9) /* WORK FILE1 */
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9) /* WORK FILE2 */
             DCL        VAR(&FILE3) TYPE(*CHAR) LEN(9) /* WORK FILE3 */
             DCL        VAR(&FILE4) TYPE(*CHAR) LEN(9) /* WORK FILE4 */
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSNO) USER(&USER)
             CHGVAR     VAR(&WT) VALUE(%SST(&WSNO 1 2))
             CHGVAR     VAR(&FILE1) VALUE('MFBWP06' *CAT &WT)
             CHGVAR     VAR(&FILE2) VALUE('MFBWP07' *CAT &WT)
             CHGVAR     VAR(&FILE3) VALUE('MFBWP09' *CAT &WT)
             CHGVAR     VAR(&FILE4) VALUE('MFBWP10' *CAT &WT)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSNO &PDEVT &PIGCD)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

/* SCREEN APPOINTMENT */
             CALL       PGM(MFBR04) PARM(&KJYU &HIZ1 &HIZ2 &SYUR +
                          &KIB1 &KIB2 &COS1 &COS2 &COS3)
             IF         COND(%SWITCH(1XXXXXXX)) THEN(GOTO CMDLBL(END))

/* WORKING DAILY REPORT DATA DETAILS LIST */
             IF         COND(&SYUR *EQ 'A') THEN(DO)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          198) LPI(6) CPI(15) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(MFBR05) PARM(&KJYU &HIZ1 &HIZ2 &KIB1 +
                          &KIB2 &COS1 &COS2 &COS3)
             DLTOVR     FILE(QPRINT)
             ENDDO

/*  FACILITY TOTAL EFFICIENCY TOTALIZATION LIST */
 /* BY COST CENTER */
             IF         COND(&SYUR *EQ 'B') THEN(DO)
             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE1) RCDLEN(100) +
                          TEXT('WORK FILE1 FOR FACILITY TOTAL EFFICIENCY') +
                          OPTION(*NOLIST) SIZE(20000 5000 3) +
                          LVLCHK(*NO)
             OVRDBF     FILE(MFBWP06) TOFILE(&FILE1)
    /* DATA SELECT */
             CALL       PGM(MFBR06) PARM(&KJYU &HIZ1 &HIZ2 &KIB1 +
                          &KIB2 &COS1 &COS2 &COS3)
             IF         COND(%SWITCH(00000000)) THEN(DO)
             DLTF       FILE(&FILE1)
             GOTO       CMDLBL(END)
             ENDDO
             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE2) RCDLEN(100) TEXT('WORK +
                          FILE2 FOR  FACILITY TOTAL EFFICIENCY') +
                          OPTION(*NOLIST) SIZE(20000 5000 3) +
                          LVLCHK(*NO)

             FMTDTA     INFILE((&WLIB/&FILE1)) +
                          OUTFILE(&WLIB/&FILE2) SRCFILE(FMTSRC) +
                          SRCMBR(MFBS06) OPTION(*NOPRT) /* COST +
                          CENTER NO MACHINE GROUP MACHINE NO PROCESS */

             OVRDBF     FILE(MFBWP07) TOFILE(&FILE2)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
    /* MAKING LIST*/
             CALL       PGM(MFBR07) PARM(&KJYU &HIZ1 &HIZ2)
             DLTF       FILE(&FILE1)
             DLTF       FILE(&FILE2)
             ENDDO

/* FACILITY TOTAL EFFICIENCY TOTALIZATION LIST */
           /* MANUFACTURING PROCESS ORDER */
             IF         COND(&SYUR *EQ 'C') THEN(DO)
             DLTF       FILE(&FILE3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE3) RCDLEN(100) +
                          TEXT('WORK FILE3 FOR FACILITY TOTAL EFFICIENCY') +
                          OPTION(*NOLIST) SIZE(20000 5000 3) +
                          LVLCHK(*NO)
             OVRDBF     FILE(MFBWP09) TOFILE(&FILE3)
    /* DATA SELECT */
             CALL       PGM(MFBR09) PARM(&KJYU &HIZ1 &HIZ2 &KIB1 +
                          &KIB2 &COS1 &COS2 &COS3)
             IF         COND(%SWITCH(00000000)) THEN(DO)
             DLTF       FILE(&FILE3)
             GOTO       CMDLBL(END)
             ENDDO
             DLTF       FILE(&FILE4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE4) RCDLEN(100) +
                          TEXT('WORK FILE4 FOR FACILITY TOTAL EFFICIENCY') +
                          OPTION(*NOLIST) SIZE(20000 5000 3) +
                          LVLCHK(*NO)

             FMTDTA     INFILE((&WLIB/&FILE3)) +
                          OUTFILE(&WLIB/&FILE4) SRCFILE(FMTSRC) +
                          SRCMBR(MFBS09) OPTION(*NOPRT) /* PROCESS +
                          MACHINE NO */

             OVRDBF     FILE(MFBWP10) TOFILE(&FILE4)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
    /* LIST MAKING */
             CALL       PGM(MFBR10) PARM(&KJYU &HIZ1 &HIZ2)
    /* DLTF FILE(&FILE3) */
    /* DLTF FILE(&FILE4) */
             ENDDO

/*  FACILITY TOTAL EFFICIENCY TOTALIZATION LIST */
           /* MANUFACTURING PROCESS ORDER */
             IF         COND(&SYUR *EQ 'D') THEN(DO)
             DLTF       FILE(&FILE3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE3) RCDLEN(100) +
                          TEXT('WORK FILE3 FOR FACILITY TOTAL EFFICIENCY') +
                          OPTION(*NOLIST) SIZE(20000 5000 3) +
                          LVLCHK(*NO)
             OVRDBF     FILE(MFBWP09) TOFILE(&FILE3)
    /* DATA SELECT */
             CALL       PGM(MFBR09) PARM(&KJYU &HIZ1 &HIZ2 &KIB1 +
                          &KIB2 &COS1 &COS2 &COS3)
             IF         COND(%SWITCH(00000000)) THEN(DO)
             DLTF       FILE(&FILE3)
             GOTO       CMDLBL(END)
             ENDDO
             DLTF       FILE(&FILE4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE4) RCDLEN(100) +
                          TEXT('WORK FILE4 FOR FACILITY TOTAL EFFICIENCY') +
                          OPTION(*NOLIST) SIZE(20000 5000 3) +
                          LVLCHK(*NO)

             FMTDTA     INFILE((&WLIB/&FILE3)) +
                          OUTFILE(&WLIB/&FILE4) SRCFILE(FMTSRC) +
                          SRCMBR(MFBS09) OPTION(*NOPRT) /* PROCESS +
                          MACHINE NO */

             OVRDBF     FILE(MFBWP10) TOFILE(&FILE4)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          198) LPI(6) CPI(15) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD)
    /* LIST MAKING */
             CALL       PGM(MFBR11) PARM(&KJYU &HIZ1 &HIZ2)
             DLTF       FILE(&FILE3)
             DLTF       FILE(&FILE4)
             ENDDO
 END:        DLTOVR     FILE(*ALL)
             ENDPGM
