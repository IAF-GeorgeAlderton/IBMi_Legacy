             PGM        PARM(&PYM)
             /** ABBC13 *****************************************/
             /*  MATERIAL TOTALIZATION LIST & COMPONENTS TOTAL  */
             /*     I-HASADA                     00.06.22       */
             /***************************************** ABBC13 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
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

             DCL        VAR(&REC)    TYPE(*DEC)  LEN(10 0)

             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             DLTF       FILE(ABBWP131)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABBWP131) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             DLTF       FILE(ABBWP132)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABBWP132) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
/* %0001 */
             DLTF       FILE(ABBWP133)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABBWP133) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
/* %0001 */

             CALL       PGM(ABBR13) PARM(&PYM &PYM1 &PYM2 &PYM3 +
                          &PYM4 &PYM5 &PYM6)

             DLTF       FILE(ABBWP14)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABBWP14) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/ABBWP131)) +
                          OUTFILE(HWFILE1/ABBWP14) SRCFILE(FMTSRC) +
                          SRCMBR(ABBS14) OPTION(*NOPRT)
             DLTF       FILE(ABBWP131)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          156) LPI(6) CPI(12) RPLUNPRT(*YES) +
                          OUTQ(PCOUTQ) FORMTYPE(K6H1) COPIES(1) +
                          MAXRCDS(*NOMAX) IGCDTA(&PIGCD)
             CALL       PGM(ABBR14) PARM(&PYM1 &PYM2 &PYM3 &PYM4 +
                          &PYM5 &PYM6)
             DLTF       FILE(ABBWP14)
             DLTOVR     FILE(QPRINT)

             DLTF       FILE(ABBWP20)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABBWP20) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/ABBWP132)) +
                          OUTFILE(HWFILE1/ABBWP20) SRCFILE(FMTSRC) +
                          SRCMBR(ABBS20) OPTION(*NOPRT)
             DLTF       FILE(ABBWP132)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          156) LPI(6) CPI(12) RPLUNPRT(*YES) +
                          OUTQ(PCOUTQ) FORMTYPE(K6H1) COPIES(1) +
                          MAXRCDS(*NOMAX) IGCDTA(&PIGCD)
             CALL       PGM(ABBR20) PARM(&PYM1 &PYM2 &PYM3 &PYM4 +
                          &PYM5 &PYM6)
             DLTF       FILE(ABBWP20)
             DLTOVR     FILE(QPRINT)
/* %0001 */
             CHGVAR     VAR(&REC) VALUE('0')
             RTVMBRD    FILE(HWFILE1/ABBWP133) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(@END))

             DLTF       FILE(ABBWP1A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABBWP1A) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/ABBWP133)) +
                          OUTFILE(HWFILE1/ABBWP1A) SRCFILE(FMTSRC) +
                          SRCMBR(ABBS14) OPTION(*NOPRT)
             DLTF       FILE(ABBWP133)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          156) LPI(6) CPI(12) RPLUNPRT(*YES) +
                          OUTQ(PCOUTQ) FORMTYPE(K6H1) COPIES(1) +
                          MAXRCDS(*NOMAX) IGCDTA(&PIGCD)
             CALL       PGM(ABBR1A) PARM(&PYM1 &PYM2 &PYM3 &PYM4 +
                          &PYM5 &PYM6)
             DLTOVR     FILE(QPRINT)
 @END:
/* %0001 */
             ENDPGM
