             PGM
             /** ABBC15 ********************/
             /* WASHER FORECAST LIST PRINT */
             /*  N-HYOTO       2000.11.28  */
             /*  N-HYOTO       2001.06.09  */
             /******************** COPY FROM ABBC14 **/
             DCL        VAR(&ABBDS3) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PYM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PYM1) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PYM2) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PYM3) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PYM4) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PYM5) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PYM6) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)

             RTVDTAARA  DTAARA(ABBDS3) RTNVAR(&ABBDS3)
             CHGVAR     VAR(&PYM) VALUE(%SST(&ABBDS3 1 6))

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

 STP1:


             DLTF       FILE(ABBWP131)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABBWP131) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             DLTF       FILE(ABBWP132)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABBWP132) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             DLTF       FILE(ABBWP133)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABBWP133) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             CALL       PGM(ABBR13) PARM(&PYM &PYM1 &PYM2 &PYM3 +
                          &PYM4 &PYM5 &PYM6)

             DLTF       FILE(ABBWP14)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABBWP14) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             FMTDTA     INFILE((&WLIB/ABBWP131)) +
                          OUTFILE(&WLIB/ABBWP14) SRCFILE(FMTSRC) +
                          SRCMBR(ABBS14) OPTION(*NOPRT)
             DLTF       FILE(ABBWP131)

             CLRPFM     FILE(ABBWP19)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          156) LPI(6) CPI(12) RPLUNPRT(*YES) +
                          OUTQ(QPRINTB) FORMTYPE(K6H1) COPIES(1) +
                          MAXRCDS(*NOMAX) IGCDTA(&PIGCD)
             CALL       PGM(ABBR14) PARM(&PYM1 &PYM2 &PYM3 &PYM4 +
                          &PYM5 &PYM6)
             DLTF       FILE(ABBWP14)
             DLTOVR     FILE(QPRINT)

             DLTF       FILE(ABBWP20)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABBWP20) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             FMTDTA     INFILE((&WLIB/ABBWP132)) +
                          OUTFILE(&WLIB/ABBWP20) SRCFILE(FMTSRC) +
                          SRCMBR(ABBS20) OPTION(*NOPRT)
             DLTF       FILE(ABBWP132)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          156) LPI(6) CPI(12) RPLUNPRT(*YES) +
                          OUTQ(QPRINTB) FORMTYPE(K6H1) COPIES(1) +
                          MAXRCDS(*NOMAX) IGCDTA(&PIGCD)
             CLRPFM     FILE(ABBWP17)
             CALL       PGM(ABBR20) PARM(&PYM1 &PYM2 &PYM3 &PYM4 +
                          &PYM5 &PYM6)
             DLTF       FILE(ABBWP20)
             DLTOVR     FILE(QPRINT)

             DLTF       FILE(ABBWP1A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABBWP1A) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             FMTDTA     INFILE((&WLIB/ABBWP133)) +
                          OUTFILE(&WLIB/ABBWP1A) SRCFILE(FMTSRC) +
                          SRCMBR(ABBS14) OPTION(*NOPRT)
             DLTF       FILE(ABBWP133)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          156) LPI(6) CPI(12) RPLUNPRT(*YES) +
                          OUTQ(QPRINTB) FORMTYPE(K6H1) COPIES(1) +
                          MAXRCDS(*NOMAX) IGCDTA(&PIGCD)
             CALL       PGM(ABBR1A) PARM(&PYM1 &PYM2 &PYM3 &PYM4 +
                          &PYM5 &PYM6)
             DLTOVR     FILE(QPRINT)


 END:        ENDPGM
