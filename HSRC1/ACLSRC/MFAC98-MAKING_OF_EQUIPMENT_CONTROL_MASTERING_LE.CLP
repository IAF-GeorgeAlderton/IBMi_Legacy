             PGM
             /** MFAC04 **************************************/
             /* MAKING OF EQUIPMENT CONTROL MASTERING LEDGER */
             /*        M.                91.01.11            */
             /********************************** MFAC04 ******/
             DCLF       FILE(MFAPW04)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE3) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE4) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE5) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE6) TYPE(*CHAR) LEN(9)
             RTVJOBA    JOB(&WS)

             CHGJOB     SWS(00000000)
             CHGVAR     VAR(&WT) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(&FILE1) VALUE('MFAWP04' *CAT &WT)
             CHGVAR     VAR(&FILE2) VALUE('MFAWP05' *CAT &WT)
             CHGVAR     VAR(&FILE3) VALUE('MFAWP06' *CAT &WT)
             CHGVAR     VAR(&FILE4) VALUE('MFAWP07' *CAT &WT)
             CHGVAR     VAR(&FILE5) VALUE('MFAWP08' *CAT &WT)
             CHGVAR     VAR(&FILE6) VALUE('MFAWP09' *CAT &WT)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

 STP1:       SNDRCVF    DEV(&WS) RCDFMT(MFAPW041)
             IF         (&IN01 *EQ '1') GOTO END

    /*       IF         COND(&IN07 *EQ '1') THEN(DO)   */
    /*       CALL       PGM(MFEC20)                    */
    /*       GOTO STP1                                 */
    /*       ENDDO                                     */

             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN12) VALUE('0')
             CHGVAR     VAR(&IN14) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&KOJO *EQ '0111') GOTO ST01
             IF         (&KOJO *EQ '9999') GOTO ST01
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@MSG) +
                          VALUE('THE FACTORY CODE IS NOT CORRECT.')
             GOTO       CMDLBL(STP1)

 ST01:       IF         COND(&LIST *EQ '7' *AND &SETB *NE '1' *AND +
                          &SETB *NE '2' *AND &SETB *NE '3') THEN(DO)
             CHGVAR     VAR(&IN12) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@MSG) VALUE('THE EQUIPMENT DIVISION +
                                   IS NOT CORRECT.')
             GOTO       STP1
             ENDDO

             IF         COND(&LIST *NE '1' *AND &LIST *NE '2' *AND +
                          &LIST *NE '3' *AND &LIST *NE '4' *AND &LIST +
                          *NE '5' *AND &LIST *NE '6' *AND &LIST *NE +
                          '7' *AND &LIST *NE '8') THEN(DO)
             CHGVAR     VAR(&IN14) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@MSG) VALUE('THE LIST KIND IS NOT CORRECT.')
             GOTO       STP1
             ENDDO

             IF         (&IN05 *NE '1') GOTO STP1

 /* LIST DIVISION = '1' */
             IF         COND(&LIST *EQ '1') THEN(DO)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(100000 10000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MFAWP04) TOFILE(&FILE1)
             CALL       PGM(MFAR04) PARM(&KOJO &SETB &LIST)

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(100000 10000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) SRCFILE(FMTSRC) +
                          SRCMBR(MFAS4A) OPTION(*NOPRT)
             DLTF       FILE(&FILE1)

             OVRPRTF    FILE(QPRINT) DEVTYPE(*IPDS) PAGESIZE(66 198) +
                          LPI(6) CPI(15) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) HOLD(*YES)
             OVRDBF     FILE(MFAWP05) TOFILE(&FILE2)
             CALL       PGM(MFAR21) PARM(&KOJO &SETB &LIST)
             DLTF       FILE(&FILE2)
             DLTOVR     FILE(*ALL)

             ENDDO

 /* LIST DIVISION = '2' */
             IF         COND(&LIST *EQ '2') THEN(DO)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(100000 10000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MFAWP04) TOFILE(&FILE1)
             CALL       PGM(MFAR04) PARM(&KOJO &SETB &LIST)

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(100000 10000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) SRCFILE(FMTSRC) +
                          SRCMBR(MFAS04) OPTION(*NOPRT)
             DLTF       FILE(&FILE1)

             OVRPRTF    FILE(QPRINT) DEVTYPE(*IPDS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          HOLD(*YES)
             OVRDBF     FILE(MFAWP05) TOFILE(&FILE2)
             CALL       PGM(MFAR05) PARM(&KOJO &SETB &LIST)
             DLTF       FILE(&FILE2)
             DLTOVR     FILE(*ALL)

             ENDDO

 /* LIST DIVISION = '3' */
             IF         COND(&LIST *EQ '3') THEN(DO)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(100000 10000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MFAWP04) TOFILE(&FILE1)
             CALL       PGM(MFAR04) PARM(&KOJO &SETB &LIST)

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(100000 10000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) SRCFILE(FMTSRC) +
                          SRCMBR(MFAS4B) OPTION(*NOPRT)
             DLTF       FILE(&FILE1)

             OVRPRTF    FILE(QPRINT) DEVTYPE(*IPDS) PAGESIZE(66 198) +
                          LPI(6) CPI(15) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) HOLD(*YES)
             OVRDBF     FILE(MFAWP05) TOFILE(&FILE2)
             CALL       PGM(MFAR21) PARM(&KOJO &SETB &LIST)
             DLTF       FILE(&FILE2)
             DLTOVR     FILE(*ALL)

             ENDDO

 /* LIST DIVISION = '4' */
             IF         COND(&LIST *EQ '4') THEN(DO)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(100000 10000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MFAWP04) TOFILE(&FILE1)
             CALL       PGM(MFAR04) PARM(&KOJO &SETB &LIST)

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(100000 10000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) SRCFILE(FMTSRC) +
                          SRCMBR(MFAS4C) OPTION(*NOPRT)
             DLTF       FILE(&FILE1)

             OVRPRTF    FILE(QPRINT) DEVTYPE(*IPDS) PAGESIZE(66 198) +
                          LPI(6) CPI(15) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) HOLD(*YES)
             OVRDBF     FILE(MFAWP05) TOFILE(&FILE2)
             CALL       PGM(MFAR21) PARM(&KOJO &SETB &LIST)
             DLTF       FILE(&FILE2)
             DLTOVR     FILE(*ALL)

             ENDDO

 /* LIST DIVISION = '5' */
             IF         COND(&LIST *EQ '5') THEN(DO)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(100000 10000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MFAWP04) TOFILE(&FILE1)
             CALL       PGM(MFAR04) PARM(&KOJO &SETB &LIST)

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(100000 10000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) SRCFILE(FMTSRC) +
                          SRCMBR(MFAS5C) OPTION(*NOPRT)
             DLTF       FILE(&FILE1)

             OVRPRTF    FILE(QPRINT) DEVTYPE(*IPDS) PAGESIZE(66 198) +
                          LPI(6) CPI(15) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) HOLD(*YES)
             OVRDBF     FILE(MFAWP05) TOFILE(&FILE2)
             CALL       PGM(MFAR21) PARM(&KOJO &SETB &LIST)
             DLTF       FILE(&FILE2)
             DLTOVR     FILE(*ALL)

             ENDDO

 /* LIST DIVISION = '6' */
             IF         COND(&LIST *EQ '6') THEN(DO)

             DLTF       FILE(&FILE3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE3) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(100000 10000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MFAWP06) TOFILE(&FILE3)
             CALL       PGM(MFAR06) PARM(&KOJO &SETB &LIST)

             DLTF       FILE(&FILE4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE4) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(100000 10000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/&FILE3)) +
                          OUTFILE(HWFILE1/&FILE4) SRCFILE(FMTSRC) +
                          SRCMBR(MFAS06) OPTION(*NOPRT)
             DLTF       FILE(&FILE3)

             OVRPRTF    FILE(QPRINT) DEVTYPE(*IPDS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          HOLD(*YES)
             OVRDBF     FILE(MFAWP07) TOFILE(&FILE4)
             CALL       PGM(MFAR07) PARM(&KOJO &SETB &LIST)
             DLTF       FILE(&FILE4)
             DLTOVR     FILE(*ALL)

             ENDDO

 /* LIST DIVISION = '7' */
             IF         COND(&LIST *EQ '7') THEN(DO)

             DLTF       FILE(&FILE5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE5) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(100000 10000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MFAWP08) TOFILE(&FILE5)
             CALL       PGM(MFAR08) PARM(&KOJO &SETB &LIST)

             DLTF       FILE(&FILE6)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE6) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(100000 10000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/&FILE5)) +
                          OUTFILE(HWFILE1/&FILE6) SRCFILE(FMTSRC) +
                          SRCMBR(MFAS08) OPTION(*NOPRT)
             DLTF       FILE(&FILE5)

             OVRPRTF    FILE(QPRINT) DEVTYPE(*IPDS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          HOLD(*YES)
             OVRDBF     FILE(MFAWP09) TOFILE(&FILE6)
             CALL       PGM(MFAR09) PARM(&KOJO &SETB &LIST)
             DLTF       FILE(&FILE6)
             DLTOVR     FILE(*ALL)

             ENDDO

 /* LIST DIVISION = '8' */
             IF         COND(&LIST *EQ '8') THEN(DO)
             OVRPRTF    FILE(QPRINT) DEVTYPE(*IPDS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          HOLD(*YES)
             CALL       PGM(MFAR10) PARM(&KOJO)
             DLTOVR     FILE(*ALL)
             ENDDO

 END:        ENDPGM
