             PGM
             /** AH#C40 **************************/
             /* A-PICS KANBAN PUBLICATION TOTALIZATION LIST */
             /*       E.KAWASHIMA G.B.C 89.07.13 */
             /************************** AH#C40 **/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BM) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PLST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE3) TYPE(*CHAR) LEN(9)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WS)    USER(&US)
             CHGJOB     RUNPTY(40) SWS(00000000)

             CHGVAR     VAR(&WT) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(&FILE1) VALUE('AH#WP40' *CAT &WT)
             CHGVAR     VAR(&FILE2) VALUE('AH#WP41' *CAT &WT)
             CHGVAR     VAR(&FILE3) VALUE('AH#WP42' *CAT &WT)
             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO)

             OVRDBF     FILE(AH#WP40) TOFILE(&FILE1)
             CALL       PGM(AH#R40) PARM(&SRE &BM &WY &WM)

             IF         COND(&BM *EQ '8888' *OR &BM *EQ '9999' *OR +
                          &BM *EQ '9431') THEN(DO)

             CHGVAR     VAR(&PLST) VALUE(' ')

             DLTF       FILE(AH#WP70)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AH#WP70) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(30000) LVLCHK(*NO) +
                          AUT(*ALL)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          OVRFLW(55) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(AH#R70) PARM(&WY &WM &US &PLST)
             DLTOVR     FILE(QPRINT)

             IF         (&PLST *NE '*') DO
             DLTF       FILE(AH#WP70)
             GOTO       GST1
             ENDDO

             DLTF       FILE(AH#WP71)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AH#WP71) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(30000) LVLCHK(*NO) +
                          AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/AH#WP70)) +
                          OUTFILE(HWFILE1/AH#WP71) SRCFILE(FMTSRC) +
                          SRCMBR(AH#S70) OPTION(*NOPRT)
             DLTF       FILE(AH#WP70)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(AH#R71) PARM(&US &WY &WM)
             DLTF       FILE(AH#WP71)
             DLTOVR     FILE(*ALL)

 GST1:       IF         COND(&BM *EQ '8888' *OR &BM *EQ '9999') +
                          THEN(DO)
             GOTO       CMDLBL(STP1)
             ENDDO

             DLTF       FILE(&FILE1)
             GOTO       CMDLBL(END)
             ENDDO

 STP1:       IF         COND(%SWITCH(0XXXXXXX)) THEN(DO)
             DLTF       FILE(&FILE1)
             GOTO       END
             ENDDO

             IF         COND(&SRE *EQ '8907') THEN(GOTO @001)

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO)

             FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) SRCFILE(FMTSRC) +
                          SRCMBR(AH#S40) OPTION(*NOPRT)
             DLTF       FILE(&FILE1)

             OVRPRTF    FILE(AH#PR41) DEVTYPE(*AFPDS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QPRINTA) FORMTYPE(K6H1)
             OVRDBF     FILE(AH#WP41) TOFILE(&FILE2)
             CALL       PGM(AH#R41) PARM(&US)
             DLTF       FILE(&FILE2)
             DLTOVR     FILE(*ALL)

 @001:       IF         COND(&SRE *EQ '8907') THEN(DO)

             DLTF       FILE(&FILE3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE3) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO)

             FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE3) SRCFILE(FMTSRC) +
                          SRCMBR(AH#S42) OPTION(*NOPRT)
             DLTF       FILE(&FILE1)

             OVRDBF     FILE(AH#WP42) TOFILE(&FILE3)
             OVRPRTF    FILE(AH#PR42) DEVTYPE(*AFPDS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QPRINTA) FORMTYPE(K6H1)
             CALL       PGM(AH#R42) PARM(&US)
             DLTF       FILE(&FILE3)
             DLTOVR     FILE(*ALL)

             ENDDO

 END:        CHGJOB     RUNPTY(20)

             ENDPGM
