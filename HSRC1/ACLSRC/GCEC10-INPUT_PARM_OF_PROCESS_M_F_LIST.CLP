             PGM
             /** GCEC10 **************************************/
             /*INPUT PARM OF PROCESS M/F LIST   */
             /*           I-HASADA        86.10.29           */
             /************************************** GCEC10 **/
             DCLF       FILE(GCEPW11)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PFDAT) TYPE(*CHAR) LEN(120)
             DCL        VAR(&PSYS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB) TYPE(*CHAR) LEN(8)

             CHGJOB     RUNPTY(40) SWS(00000000)
             RTVJOBA    JOB(&WSID) USER(&US)
             RTVNETA    SYSNAME(&PSYS)
             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(ALBC00) PARM(&US &WLIB)

             IF         (&PSYS *EQ 'KANI    ') DO
             CHGJOB     DATE('921101')
             ENDDO

             CHGVAR     VAR(&FILE1) VALUE('GCEWP10' *CAT &WS)
             CHGVAR     VAR(&FILE2) VALUE('GCEWP11' *CAT &WS)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(GCEPW111)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN05) VALUE('0')
             CHGVAR     VAR(&IN06) VALUE('0')
             CHGVAR     VAR(&IN07) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         ((&FNO *NE '1') *AND (&FNO *NE '2') *AND +
                          (&FNO *NE '3') *AND (&FNO *NE '4') *AND +
                          (&FNO *NE '5')) DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT SELECT NO. < 1.2.3 >')
             GOTO STP1
             ENDDO

             IF         ((&FMT *NE 'M') *AND (&FMT *NE 'T')) DO
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT INSTRUCTION < M.T >  ')
             GOTO STP1
             ENDDO

             IF         ((&FYO *NE '6') *AND (&FYO *NE '8')) DO
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT PAPER INSTRUCTION < 6.8 >  ')
             GOTO STP1
             ENDDO

             IF         ((&FPR *NE '1') *AND (&FPR *NE '2')) DO
             CHGVAR     VAR(&IN05) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT PRINTER INSTRUCTION < 1.2 > ')
             GOTO STP1
             ENDDO

             IF         ((&FKB *NE 'Y') *AND (&FKB *NE 'N')) DO
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('REVERSING INSTRUCTION IS < Y-YES . +
                          N-NO >')
             GOTO STP1
             ENDDO

             IF         ((&FMEIK *NE 'Y') *AND (&FMEIK *NE 'N')) DO
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('REVERSING INSTRUCTION IS < Y-YES . +
                          N-NO >')
             GOTO STP1
             ENDDO

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE1) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(2000 2000 3) LVLCHK(*NO)

             OVRPRTF    FILE(QPRINT2) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             OVRDBF     FILE(GCEWP10) TOFILE(&FILE1)
             CALL       PGM(GCER10) PARM(&FNO &PFDAT &FMEIK)
             DLTOVR     FILE(GCEWP10)
             DLTOVR     FILE(QPRINT2)

             IF         (%SWITCH(0XXXXXXX)) GOTO STP3
 STP4:       SNDPGMMSG  MSG('** ( G ) CALENDAR FILE BEING WRONG, +
                          CONTACT YOU TO EDP SECTION.**') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(RETURN)
             GOTO       STP4

 STP3:       IF         (%SWITCH(X1XXXXXX)) GOTO STP5
             DLTF       FILE(&FILE1)
             GOTO       END

 STP5:       DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE2) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(2000 2000 3) LVLCHK(*NO)

             IF         (&FNO *EQ '1') GOTO STP6
             IF         (&FNO *EQ '2') GOTO STP7
             IF         (&FNO *EQ '3') GOTO STP8
             IF         (&FNO *EQ '5') GOTO STP10

             FMTDTA     INFILE((&WLIB/&FILE1)) OUTFILE(&WLIB/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GCES51) +
                          OPTION(*NOPRT)
             GOTO       STP9

 STP6:       FMTDTA     INFILE((&WLIB/&FILE1)) OUTFILE(&WLIB/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GCES48) +
                          OPTION(*NOPRT)
             GOTO       STP9

 STP7:       FMTDTA     INFILE((&WLIB/&FILE1)) OUTFILE(&WLIB/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GCES49) +
                          OPTION(*NOPRT)
             GOTO       STP9

 STP8:       FMTDTA     INFILE((&WLIB/&FILE1)) OUTFILE(&WLIB/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GCES50) +
                          OPTION(*NOPRT)
             GOTO       STP9

 STP10:      FMTDTA     INFILE((&WLIB/&FILE1)) OUTFILE(&WLIB/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GCES52) +
                          OPTION(*NOPRT)

 STP9:       DLTF       FILE(&FILE1)

             OVRDBF     FILE(GCEWP11) TOFILE(&FILE2)

             IF         COND(&FPR *EQ '1') THEN(CHGVAR VAR(&PRTG) +
                          VALUE('QPRINTJ'))
             IF         (&FYO *EQ '8') GOTO STP11
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             GOTO       STP12

 STP11:      OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(88 +
                          132) LPI(8) OVRFLW(80) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K8H1) IGCDTA(&PIGCD)

 STP12:      IF         (&FKB *EQ 'N') GOTO STP13
             CALL       PGM(GCER12) PARM(&US &FNO &FMT &PFDAT)
             GOTO       STP14

 STP13:      CALL       PGM(GCER11) PARM(&US &FNO &FMT &PFDAT &FMEIK)
 STP14:      DLTF       FILE(&FILE2)
             DLTOVR     FILE(GCEWP11)
             DLTOVR     FILE(QPRINT)

 END:        CHGJOB     RUNPTY(20)

             ENDPGM
