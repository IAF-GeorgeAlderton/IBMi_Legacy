             PGM
             /** MFBC80 ************************************/
             /* ..LIST OF WORK DAILY BULLETIN DATA..       */
             /*       CREATE DATE : 1998.01.12             */
             /*       AUTHOR      : K.OKACHI.              */
             /**********************************************/
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             DCL        VAR(&WS)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&NO)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&REC)    TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&FILE)  TYPE(*CHAR)  LEN(9)
             DCL        VAR(&FILE1)  TYPE(*CHAR)  LEN(9)
             DCL        VAR(&FILE2)  TYPE(*CHAR)  LEN(9)
             DCL        VAR(&FILE3)  TYPE(*CHAR)  LEN(9)
             DCL        VAR(&FILE4)  TYPE(*CHAR)  LEN(9)
             DCL        VAR(&FILE5)  TYPE(*CHAR)  LEN(9)
             DCL        VAR(&FILE6)  TYPE(*CHAR)  LEN(9)

             RTVJOBA    JOB(&WSID)   USER(&US)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))

             CHGVAR     VAR(&FILE)  VALUE('MFBWP80' *CAT &WS)
             CHGVAR     VAR(&FILE1) VALUE('MFBWP81' *CAT &WS)
             CHGVAR     VAR(&FILE2) VALUE('MFBWP82' *CAT &WS)
             CHGVAR     VAR(&FILE3) VALUE('MFBWP83' *CAT &WS)
             CHGVAR     VAR(&FILE4) VALUE('MFBWP84' *CAT &WS)
             CHGVAR     VAR(&FILE5) VALUE('MFBWP85' *CAT &WS)
             CHGVAR     VAR(&FILE6) VALUE('MFBWP86' *CAT &WS)

             DLTF       FILE(HWFILE1/&FILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE) RCDLEN(200) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MFBWP80) TOFILE(HWFILE1/&FILE)

             CALL       PGM(MFBR80) PARM(&NO)

             CHGVAR     VAR(&REC) VALUE('0')
             RTVMBRD    FILE(HWFILE1/&FILE) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(END))


             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          198) LPI(6) CPI(15) OVRFLW(62) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
 /*  AS400 NO.3 TEST */
 /*          OVRPRTF    FILE(QPRINT) DEVTYPE(*SCS) PAGESIZE(66 198) +
                          LPI(6) CPI(15) OVRFLW(62) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1)              */

             IF         (&NO   *EQ '1') GOTO STEP1
             IF         (&NO   *EQ '2') GOTO STEP2
             IF         (&NO   *EQ '3') GOTO STEP3
             IF         (&NO   *EQ '4') GOTO STEP4
             IF         (&NO   *EQ '5') GOTO STEP5
             IF         (&NO   *EQ '6') GOTO STEP6

 STEP1:      DLTF       FILE(HWFILE1/&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(200) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/&FILE)) +
                          OUTFILE(HWFILE1/&FILE1) SRCFILE(FMTSRC) +
                          SRCMBR(MFBS81) OPTION(*NOPRT)

             OVRDBF     FILE(MFBWP81) TOFILE(HWFILE1/&FILE1)
             CALL       PGM(MFBR81)

             DLTF       FILE(HWFILE1/&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)

             GOTO END

 STEP2:      DLTF       FILE(HWFILE1/&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(200) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/&FILE)) +
                          OUTFILE(HWFILE1/&FILE2) SRCFILE(FMTSRC) +
                          SRCMBR(MFBS82) OPTION(*NOPRT)

             OVRDBF     FILE(MFBWP82) TOFILE(HWFILE1/&FILE2)
             CALL       PGM(MFBR82)

             DLTF       FILE(HWFILE1/&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)

             GOTO END

 STEP3:      DLTF       FILE(HWFILE1/&FILE3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE3) RCDLEN(200) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/&FILE)) +
                          OUTFILE(HWFILE1/&FILE3) SRCFILE(FMTSRC) +
                          SRCMBR(MFBS83) OPTION(*NOPRT)

             OVRDBF     FILE(MFBWP83) TOFILE(HWFILE1/&FILE3)
             CALL       PGM(MFBR83)

             DLTF       FILE(HWFILE1/&FILE3)
             MONMSG     MSGID(CPF3261 CPF2105)

             GOTO END

 STEP4:      DLTF       FILE(HWFILE1/&FILE4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE4) RCDLEN(200) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/&FILE)) +
                          OUTFILE(HWFILE1/&FILE4) SRCFILE(FMTSRC) +
                          SRCMBR(MFBS84) OPTION(*NOPRT)

             OVRDBF     FILE(MFBWP84) TOFILE(HWFILE1/&FILE4)
             CALL       PGM(MFBR84)

             DLTF       FILE(HWFILE1/&FILE4)
             MONMSG     MSGID(CPF3261 CPF2105)

             GOTO END

 STEP5:      DLTF       FILE(HWFILE1/&FILE5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE5) RCDLEN(200) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/&FILE)) +
                          OUTFILE(HWFILE1/&FILE5) SRCFILE(FMTSRC) +
                          SRCMBR(MFBS84) OPTION(*NOPRT)

             OVRDBF     FILE(MFBWP85) TOFILE(HWFILE1/&FILE5)
             CALL       PGM(MFBR85)

             DLTF       FILE(HWFILE1/&FILE5)
             MONMSG     MSGID(CPF3261 CPF2105)

             GOTO END

 STEP6:      DLTF       FILE(HWFILE1/&FILE6)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE6) RCDLEN(200) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/&FILE)) +
                          OUTFILE(HWFILE1/&FILE6) SRCFILE(FMTSRC) +
                          SRCMBR(MFBS84) OPTION(*NOPRT)

             OVRDBF     FILE(MFBWP86) TOFILE(HWFILE1/&FILE6)
             CALL       PGM(MFBR86)

             DLTF       FILE(HWFILE1/&FILE6)
             MONMSG     MSGID(CPF3261 CPF2105)


 END:        DLTOVR     FILE(*ALL)

             DLTF       FILE(HWFILE1/&FILE)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDPGM
