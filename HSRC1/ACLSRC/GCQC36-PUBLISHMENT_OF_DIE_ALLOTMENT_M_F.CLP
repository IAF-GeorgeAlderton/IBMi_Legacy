             PGM
             /** GCQC36 **********************************/
             /*   ..PUBLISHMENT OF DIE ALLOTMENT M/F     */
             /*       I-HASADA            88.04.13       */
             /*       TCH                 00.10.05       */
             /*型構成マスター対応     2021.01.12       */
             /************************ COPY FROM GCQC32 **/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCNT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PNO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PKBN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PTYPE) TYPE(*CHAR) LEN(1) VALUE('1')
             DCL        VAR(&CNT)    TYPE(*DEC) LEN(10 0)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE3)  TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE4)  TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE5)  TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE6)  TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE7)  TYPE(*CHAR) LEN(9)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WS) USER(&US)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYP &PRTG)
             CALL       PGM(ALBC00) PARM(&US &WLIB)

             CHGVAR     VAR(%SST(&FILE1 1 7)) VALUE('GCQWP32')
             CHGVAR     VAR(%SST(&FILE1 8 2)) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(%SST(&FILE2 1 7)) VALUE('GCQWP33')
             CHGVAR     VAR(%SST(&FILE2 8 2)) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(%SST(&FILE3 1 7)) VALUE('WK350L1')
             CHGVAR     VAR(%SST(&FILE3 8 2)) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(%SST(&FILE4 1 7)) VALUE('GCQWP36')
             CHGVAR     VAR(%SST(&FILE4 8 2)) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(%SST(&FILE5 1 7)) VALUE('GCQWP37')
             CHGVAR     VAR(%SST(&FILE5 8 2)) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(%SST(&FILE6 1 7)) VALUE('GCQWP38')
             CHGVAR     VAR(%SST(&FILE6 8 2)) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(%SST(&FILE7 1 7)) VALUE('GCQWP39')
             CHGVAR     VAR(%SST(&FILE7 8 2)) VALUE(%SST(&WS 1 2))

          /*--------------------------------------------*/
             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE1) RCDLEN(512) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO)

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE2) RCDLEN(512) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO)

             DLTF       FILE(&FILE4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE4) RCDLEN(512) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO)

             DLTF       FILE(&FILE5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE5) RCDLEN(512) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO)

             DLTF       FILE(&FILE6)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE6) RCDLEN(512) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO)

             DLTF       FILE(&FILE7)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE7) RCDLEN(512) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO)

          /*--------------------------------------------*/
             OVRDBF     FILE(GCQWP32) TOFILE(&FILE1)
             CALL       PGM(GCQR32) PARM(&PCNT &PNO)
             DLTOVR     FILE(GCQWP32)

             IF         (%SWITCH(0XXXXXXX)) DO
             DLTF       FILE(&FILE1)
             GOTO       END
             ENDDO

          /*--------------------------------------------*/
             IF         (&PNO *EQ '1') DO
             FMTDTA     INFILE((&WLIB/&FILE1)) OUTFILE(&WLIB/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GCQS32) +
                          OPTION(*NOPRT)
             ENDDO
             ELSE       DO
             FMTDTA     INFILE((&WLIB/&FILE1)) OUTFILE(&WLIB/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GCQS33) +
                          OPTION(*NOPRT)
             ENDDO
             DLTF       FILE(&FILE1)

             RTVMBRD    FILE(&FILE2) NBRCURRCD(&CNT)
             IF         COND(&CNT  *NE 0) THEN(DO)

             DLTF       FILE(&FILE3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTDUPOBJ  OBJ(WK350W0) FROMLIB(HWFILE1) +
                          OBJTYPE(*FILE) TOLIB(&WLIB) NEWOBJ(&FILE3)

             OVRDBF     FILE(CCQWP02) TOFILE(&FILE2)
             OVRDBF     FILE(WK350W0) TOFILE(&FILE3)
             CALL       PGM(WK310R) PARM(&US &PKBN)

             OVRDBF     FILE(CCQWP06) TOFILE(&FILE4)
             OVRDBF     FILE(CCQWP07) TOFILE(&FILE5)
             CALL       PGM(WK311R) PARM(&US &PTYPE &PKBN)

          /*--------------------------------------------*/
             RTVMBRD    FILE(&FILE5) NBRCURRCD(&CNT)
             IF         COND(&CNT *NE 0) THEN(DO)
             IF         (&PNO *EQ '1') DO
             FMTDTA     INFILE((&FILE5)) OUTFILE(&FILE6) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GCQS32) +
                          OPTION(*NOPRT)
             ENDDO
             ELSE       DO
             FMTDTA     INFILE((&FILE5)) OUTFILE(&FILE6) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GCQS33) +
                          OPTION(*NOPRT)
             ENDDO

             OVRPRTF    FILE(GCQPR33) DEVTYPE(*SCS) PAGESIZE(66) +
                          LPI(6) OVRFLW(65) RPLUNPRT(*YES) +
                          OUTQ(IT_OUTQ) FORMTYPE(D982) +
                          COPIES(&PCNT) MAXRCDS(*NOMAX)

             OVRDBF     FILE(GCQWP33) TOFILE(&FILE6)
             CALL       PGM(GCQR33) PARM(&US)

             SNDNETSPLF FILE(GCQPR33) TOUSRID((V0030 SYSTEM1)) +
                          SPLNBR(*LAST) DTAFMT(*ALLDATA)
             MONMSG     MSGID(CPF3309 CPF0000)

             DLTSPLF    FILE(GCQPR33) SPLNBR(*LAST)
             MONMSG     MSGID(CPF3309 CPF0000)
             ENDDO

          /*--------------------------------------------*/
             RTVMBRD    FILE(&FILE4) NBRCURRCD(&CNT)
             IF         COND(&CNT *NE 0) THEN(DO)
             IF         (&PNO *EQ '1') DO
             FMTDTA     INFILE((&FILE4)) OUTFILE(&FILE7) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GCQS36) +
                          OPTION(*NOPRT)
             ENDDO
             ELSE       DO
             FMTDTA     INFILE((&FILE4)) OUTFILE(&FILE7) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GCQS37) +
                          OPTION(*NOPRT)
             ENDDO

             OVRPRTF    FILE(WK316V0) DEVTYPE(*SCS) PAGESIZE(66) +
                          LPI(6) OVRFLW(65) RPLUNPRT(*YES) +
                          OUTQ(IT_OUTQ) FORMTYPE(D982) +
                          COPIES(&PCNT) MAXRCDS(*NOMAX)

             OVRDBF     FILE(GCQWP33) TOFILE(&FILE7)
             CALL       PGM(WK316R) PARM(&US &PKBN)

             SNDNETSPLF FILE(WK316V0) TOUSRID((V0030 SYSTEM1)) +
                          SPLNBR(*LAST) DTAFMT(*ALLDATA)
             MONMSG     MSGID(CPF3309 CPF0000)

             DLTSPLF    FILE(WK316V0) SPLNBR(*LAST)
             MONMSG     MSGID(CPF3309 CPF0000)
             ENDDO

             ENDDO

             DLTF       FILE(&FILE2)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM
