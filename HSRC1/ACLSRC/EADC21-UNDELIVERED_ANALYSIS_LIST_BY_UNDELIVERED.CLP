             PGM        PARM(&STHZ &ENHZ &PNO)
             /** EADC21 **************************/
             /*UNDELIVERED ANALYSIS LIST BY UNDELIVERED FREQUENCY  */
             /* E.KAWASHIMA G.B.C 89.02.27 */
             /************************** EADC21 **/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&STHZ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&ENHZ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PNO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PKEN1) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PKEN2) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PKEN3) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PHIZ1) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PHIZ2) TYPE(*CHAR) LEN(8)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE3) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE4) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE5) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE6) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE7) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE8) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE9) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE10) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE11) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE12) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE13) TYPE(*CHAR) LEN(9)
             RTVJOBA    JOB(&WS)
             CHGJOB     SWS(00000000)

             CHGVAR     VAR(&WT) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(&FILE1) VALUE('EADWP21' *CAT &WT)
             CHGVAR     VAR(&FILE2) VALUE('EADWP22' *CAT &WT)
             CHGVAR     VAR(&FILE3) VALUE('EADWP23' *CAT &WT)
             CHGVAR     VAR(&FILE4) VALUE('EADWP24' *CAT &WT)
             CHGVAR     VAR(&FILE5) VALUE('EADWP25' *CAT &WT)
             CHGVAR     VAR(&FILE6) VALUE('EADWP28' *CAT &WT)
             CHGVAR     VAR(&FILE7) VALUE('EADWP3X' *CAT &WT)
             CHGVAR     VAR(&FILE8) VALUE('EADWP3Y' *CAT &WT)
             CHGVAR     VAR(&FILE9) VALUE('EADWP3Z' *CAT &WT)
             CHGVAR     VAR(&FILE10) VALUE('EADWP3W' *CAT &WT)
             CHGVAR     VAR(&FILE11) VALUE('EADWP36' *CAT &WT)
             CHGVAR     VAR(&FILE12) VALUE('EADWP37' *CAT &WT)
             CHGVAR     VAR(&FILE13) VALUE('EADWP38' *CAT &WT)

  /*         CALL       PGM(KZZR00) PARM(&WS &PRT &TYPE &PRTG)    */
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 5000 3) +
                          LVLCHK(*NO)

             OVRDBF     FILE(EADWP21) TOFILE(&FILE1)
             CALL       PGM(EADR21) PARM(&STHZ &ENHZ)

             IF         (%SWITCH(0XXXXXXX)) DO
                DLTF       FILE(&FILE1)
                GOTO       END
             ENDDO

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 5000 3) +
                          LVLCHK(*NO)

             FMTDTA     INFILE((&FILE1)) OUTFILE(&FILE2) +
                          SRCFILE(FMTSRC) SRCMBR(EADS21) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE1)

             DLTF       FILE(&FILE3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE3) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 5000 3) +
                          LVLCHK(*NO)

             OVRDBF     FILE(EADWP22) TOFILE(&FILE2)
             OVRDBF     FILE(EADWP23) TOFILE(&FILE3)
             CALL       PGM(EADR22)
             DLTF       FILE(&FILE2)

             DLTF       FILE(&FILE4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE4) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 5000 3) +
                          LVLCHK(*NO)

             IF         (&PNO *EQ '1') DO
                FMTDTA     INFILE((&FILE3)) OUTFILE(&FILE4) +
                             SRCFILE(FMTSRC) SRCMBR(EADS23) +
                             OPTION(*NOPRT)
                ENDDO
                ELSE       DO
                FMTDTA     INFILE((&FILE3)) OUTFILE(&FILE4) +
                             SRCFILE(FMTSRC) SRCMBR(EADS22) +
                             OPTION(*NOPRT)
             ENDDO

             DLTF       FILE(&FILE3)
             DLTF       FILE(&FILE5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE5) RCDLEN(110) +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 5000 3) +
                          LVLCHK(*NO)

             DLTF       FILE(&FILE7)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE7) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 5000 3) +
                          LVLCHK(*NO)

             OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1)
             OVRDBF     FILE(EADWP24) TOFILE(&FILE4)
             OVRDBF     FILE(EADWP25) TOFILE(&FILE5)
             OVRDBF     FILE(EADWP3X) TOFILE(&FILE7)
             CALL       PGM(EADR23) PARM(&PNO &PKEN1 &PKEN2 &PKEN3 +
                          &PHIZ1 &PHIZ2)
             DLTF       FILE(&FILE4)

             DLTF       FILE(&FILE6)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE6) RCDLEN(110) +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 5000 3) +
                          LVLCHK(*NO)

             FMTDTA     INFILE((&FILE5)) OUTFILE(&FILE6) +
                          SRCFILE(FMTSRC) SRCMBR(EADS28) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE5)

             OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1)
             OVRDBF     FILE(EADWP28) TOFILE(&FILE6)
             CALL       PGM(EADR28) PARM(&STHZ &ENHZ)
             DLTF       FILE(&FILE6)

             DLTF       FILE(&FILE8)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE8) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 5000 3) +
                          LVLCHK(*NO)

             DLTF       FILE(&FILE9)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE9) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 5000 3) +
                          LVLCHK(*NO)

             DLTF       FILE(&FILE10)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE10) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 5000 3) +
                          LVLCHK(*NO)

             DLTF       FILE(&FILE11)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE11) SRCFILE(ADDSSRC) +
                          SRCMBR(EADWP36) OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 5000 3) LVLCHK(*NO)

             DLTF       FILE(&FILE12)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE12) SRCFILE(ADDSSRC) +
                          SRCMBR(EADWP37) OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 5000 3) LVLCHK(*NO)

             DLTF       FILE(&FILE13)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE13) SRCFILE(ADDSSRC) +
                          SRCMBR(EADWP38) OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 5000 3) LVLCHK(*NO)

             FMTDTA     INFILE((&FILE7)) OUTFILE(&FILE8) +
                          SRCFILE(FMTSRC) SRCMBR(EADS36) +
                          OPTION(*NOPRT)

             FMTDTA     INFILE((&FILE7)) OUTFILE(&FILE9) +
                          SRCFILE(FMTSRC) SRCMBR(EADS37) +
                          OPTION(*NOPRT)

             FMTDTA     INFILE((&FILE7)) OUTFILE(&FILE10) +
                          SRCFILE(FMTSRC) SRCMBR(EADS38) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE7)

             OVRDBF     FILE(EADWP3Y) TOFILE(&FILE8)
             OVRDBF     FILE(EADWP36) TOFILE(&FILE11)
             CALL       PGM(EADR36)
             DLTF       FILE(&FILE8)

             OVRDBF     FILE(EADWP3Z) TOFILE(&FILE9)
             OVRDBF     FILE(EADWP37) TOFILE(&FILE12)
             CALL       PGM(EADR37)
             DLTF       FILE(&FILE9)

             OVRDBF     FILE(EADWP3W) TOFILE(&FILE10)
             OVRDBF     FILE(EADWP38) TOFILE(&FILE13)
             CALL       PGM(EADR38)
             DLTF       FILE(&FILE10)

             OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1)
             CALL       PGM(EADR39) PARM(&PKEN1 &PKEN2 &PKEN3 &PHIZ1 +
                          &PHIZ2)
             DLTF       FILE(&FILE11)
             DLTF       FILE(&FILE12)
             DLTF       FILE(&FILE13)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM
