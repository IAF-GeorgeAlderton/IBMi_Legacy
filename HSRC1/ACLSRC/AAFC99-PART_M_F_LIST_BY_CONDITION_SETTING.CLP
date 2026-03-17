             PGM
             /** AAFC30 **************************************/
             /*PART M/F LIST  BY  CONDITION SETTING */
             /*         I-HASADA            86.10.16         */
             /************************************** AAFC30 **/
             DCLF       FILE(AAFPW31)
             DCL        VAR(&MCEDP01) TYPE(*CHAR) LEN(8)
             DCL        VAR(&US)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&MBAN)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PDATA)   TYPE(*CHAR) LEN(233)
             DCL        VAR(&FILE1)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&PHIZK)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&PSYS)    TYPE(*CHAR) LEN(8)

             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)
             RTVJOBA    JOB(&WS) USER(&US)
             RTVNETA    SYSNAME(&PSYS)

             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             MONMSG     MSGID(CPF2103)

             CHGJOB     RUNPTY(40) SWS(00000000)

             IF         (&PSYS *EQ 'KANI    ') DO
                CHGJOB     DATE('921101')
             ENDDO

             CHGVAR     VAR(&PHIZK) VALUE(&MCEDP01)
             CHGVAR     VAR(&FHIZK) VALUE(%SST(&MCEDP01 1 6))
             CHGVAR     VAR(&WHIZK) VALUE(&FHIZK)
             CHGVAR     VAR(&WSID)  VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(&FILE1) VALUE(AAFWP30 *CAT &WSID)
             CHGVAR     VAR(&FILE2) VALUE(AAFWP31 *CAT &WSID)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)

             CHGVAR     VAR(&JYU) VALUE('S')

 STP1:       SNDRCVF    DEV(&WS) RCDFMT(AAFPW311)

             IF         (&IN01 *EQ '1') GOTO END

             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN05) VALUE('0')
             CHGVAR     VAR(&IN06) VALUE('0')
             CHGVAR     VAR(&IN07) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         COND(&FKUBN *LT 01 *OR &FKUBN *GT 16) THEN(DO)
                CHGVAR  VAR(&IN02) VALUE('1')
                CHGVAR  VAR(&IN99) VALUE('1')
                CHGVAR  VAR(&MSG) VALUE('INPUT SELECT NO. < 1 - 16 > ')
                GOTO    CMDLBL(STP1)
             ENDDO

             IF         COND(&FHIZK *EQ '      ') THEN(DO)
                CHGVAR     VAR(&IN05) VALUE('1')
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR     VAR(&MSG)  VALUE('RESULT DATE IS NOT INPUT')
                GOTO       STP1
             ENDDO

             IF         (%SST(&FHIZK 1 4) *LT '1984') GOTO STPX
             IF         (%SST(&FHIZK 5 2) *GT '12')   GOTO STPX
             IF         (%SST(&FHIZK 5 2) *LT '01')   GOTO STPX
             GOTO       STPY

 STPX:       CHGVAR     VAR(&IN05) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG)  VALUE('RESULT DATE ISN')
             GOTO       STP1

 STPY:       IF         COND(&FP *LT '1' *OR &FP *GT '2') THEN(DO)
                CHGVAR  VAR(&IN03) VALUE('1')
                CHGVAR  VAR(&IN99) VALUE('1')
                CHGVAR  VAR(&MSG)  VALUE('PRINTER INSTRUCTION < 1.2 >')
                GOTO    STP1
             ENDDO

             IF         (&FMT *NE 'M' *AND &FMT *NE 'T') DO
                CHGVAR  VAR(&IN06) VALUE('1')
                CHGVAR  VAR(&IN99) VALUE('1')
                CHGVAR  VAR(&MSG) VALUE('INSTRUCTION < M.T > INPUT IT')
                GOTO STP1
             ENDDO

             IF         (&YOSI *NE '6' *AND &YOSI *NE '8') DO
                CHGVAR    VAR(&IN04) VALUE('1')
                CHGVAR    VAR(&IN99) VALUE('1')
                CHGVAR    VAR(&MSG)  VALUE('PAPER INSTRUCTION < 6.8 >')
                GOTO      STP1
             ENDDO

             IF         (&JYU *NE 'S' *AND &JYU *NE 'K') DO
                CHGVAR     VAR(&IN07) VALUE('1')
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR     VAR(&MSG) VALUE('INPUT INSTRUCTION < S.K >')
                GOTO STP1
             ENDDO

             CHGVAR     VAR(%SST(&PHIZK 1 6)) VALUE(&FHIZK)

             IF         COND(&FP *EQ '1') THEN(CHGVAR VAR(&PRTG) +
                          VALUE('QPRINT    '))
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(120) +
                          OPTION(*NOLIST) SIZE(2000 2000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AAFWP30) TOFILE(&FILE1)
             CALL       PGM(AAFR30) PARM(&PHIZK &PDATA)
             DLTOVR     FILE(AAFWP30)

             IF         (%SWITCH(0XXXXXXX)) GOTO PY2
             DLTF       FILE(&FILE1)

 VTP2:       SNDPGMMSG  MSG('** ( G ) CALENDAR FILE IS WRONG.INFORM +
                          YOU TO COMUTATION ROOM **') TOMSGQ(&WS) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)

             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       VTP2

 PY2:        IF         (%SWITCH(X1XXXXXX)) GOTO VTP1
             DLTF       FILE(&FILE1)
             GOTO       END

 VTP1:       CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(120) +
                          OPTION(*NOLIST) SIZE(2000 2000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             IF         COND(&FKUBN *EQ 02) THEN(GOTO CMDLBL(STP3))
             IF         COND(&FKUBN *EQ 03) THEN(GOTO CMDLBL(STP4))
             IF         COND(&FKUBN *EQ 04) THEN(GOTO CMDLBL(STP5))
             IF         COND(&FKUBN *EQ 05) THEN(GOTO CMDLBL(STP6))
             IF         COND(&FKUBN *EQ 06) THEN(GOTO CMDLBL(STP7))
             IF         COND(&FKUBN *EQ 07) THEN(GOTO CMDLBL(STP8))
             IF         COND(&FKUBN *EQ 08) THEN(GOTO CMDLBL(STP9))
             IF         COND(&FKUBN *EQ 09) THEN(GOTO CMDLBL(STP10))
             IF         COND(&FKUBN *EQ 10) THEN(GOTO CMDLBL(STP12))
             IF         COND(&FKUBN *EQ 11) THEN(GOTO CMDLBL(STP13))
             IF         COND(&FKUBN *EQ 12) THEN(GOTO CMDLBL(STP14))
             IF         COND(&FKUBN *EQ 13) THEN(GOTO CMDLBL(STP15))
             IF         COND(&FKUBN *EQ 14) THEN(GOTO CMDLBL(STP16))
             IF         COND(&FKUBN *EQ 15) THEN(GOTO CMDLBL(STP17))
             IF         COND(&FKUBN *EQ 16) THEN(GOTO CMDLBL(STP18))

             FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AAFS30) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE1)
             GOTO       STP11

 STP3:       FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AAFS31) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE1)
             GOTO       STP11

 STP4:       FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AAFS32) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE1)
             GOTO       STP11

 STP5:       FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AAFS33) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE1)
             GOTO       STP11

 STP6:       FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AAFS34) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE1)
             GOTO       STP11

 STP7:       FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AAFS35) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE1)
             GOTO       STP11

 STP8:       FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AAFS36) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE1)
             GOTO       STP11

 STP9:       FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AAFS37) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE1)
             GOTO       STP11

 STP10:      FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AAFS38) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE1)
             GOTO       STP11

 STP12:      FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AAFS39) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE1)
             GOTO       STP11

 STP13:      FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AAFS40) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE1)
             GOTO       STP11

 STP14:      FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AAFS41) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE1)
             GOTO       STP11

 STP15:      FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AAFS42) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE1)
             GOTO       STP11

 STP16:      FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AAFS43) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE1)
             GOTO       STP11

 STP17:      FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AAFS44) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE1)
             GOTO       STP11

 STP18:      FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AAFS29) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE1)

 STP11:      IF         (&YOSI *EQ '8') GOTO DP1
             OVRPRTF    FILE(QPRINT) PAGESIZE(66 132) LPI(6) +
                          OVRFLW(60) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1)
             GOTO       DP2

 DP1:        OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(88 +
                          132) LPI(8) OVRFLW(80) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K8H1) IGCDTA(&PIGCD)

 DP2:        OVRDBF     FILE(AAFWP31) TOFILE(&FILE2)
             CALL       PGM(AAFR31) PARM(&US &PHIZK &FKUBN &PDATA +
                          &FMT &JYU)
             DLTF       FILE(&FILE2)
             DLTOVR     FILE(QPRINT)
             DLTOVR     FILE(AAFWP31)
             MONMSG     MSGID(CPF2128)

 END:        CHGJOB     RUNPTY(20)

             ENDPGM
