             PGM
             /** MBEC90 ************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)

             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             DLTF       FILE(MBEWP90)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/MBEWP90) RCDLEN(512) +
                          OPTION(*NOLIST) SIZE(2000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)
             OVRDBF OUTPUT1 &WLIB/MBEWP90
             CALL       PGM(MBER90)
             RTVMBRD    FILE(&WLIB/MBEWP90) NBRCURRCD(&REC)
             IF (&REC *NE 0) DO
             FMTDTA     INFILE((&WLIB/MBEWP90)) +
                          OUTFILE(&WLIB/MBEWP90) SRCFILE(FMTSRC) +
                          SRCMBR(MBES90) OPTION(*NOPRT)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          198) LPI(6) CPI(15) OVRFLW(62) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          MAXRCDS(*NOMAX) HOLD(*YES) IGCDTA(&PIGCD)
             CALL MBER91
             ENDDO
             DLTOVR *ALL

             ENDPGM
