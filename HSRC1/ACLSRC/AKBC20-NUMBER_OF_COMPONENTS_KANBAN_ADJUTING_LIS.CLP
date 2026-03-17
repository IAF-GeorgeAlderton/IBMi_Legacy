             PGM
             /** AKBC20 ************************************/
             /* NUMBER OF COMPONENTS  KANBAN ADJUTING LIST */
             /*                                            */
             /* CODING:K.OKACHI         2000.12.13         */
             /**********************************************/
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             DCL        VAR(&ABBDS3) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PKYM)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&MCEDP01) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PGYM)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&WS)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&REC)    TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&FILE1)  TYPE(*CHAR)  LEN(9)
             DCL        VAR(&FILE2)  TYPE(*CHAR)  LEN(9)

             RTVDTAARA  DTAARA(ABBDS3) RTNVAR(&ABBDS3)
             CHGVAR     VAR(&PKYM) VALUE(%SST(&ABBDS3 1 6))
             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)
             CHGVAR     VAR(&PGYM) VALUE(%SST(&MCEDP01 1 6))

             RTVJOBA    JOB(&WSID)   USER(&US)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))

             CHGVAR     VAR(&FILE1) VALUE('AKBWP20' *CAT &WS)
             CHGVAR     VAR(&FILE2) VALUE('AKBWP21' *CAT &WS)

             DLTF       FILE(HWFILE1/&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(128) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AKBWP201) TOFILE(HWFILE1/&FILE1)
             CALL       PGM(AKBR20) PARM(&PKYM &PGYM)
             DLTOVR     FILE(*ALL)

             CHGVAR     VAR(&REC) VALUE('0')
             RTVMBRD    FILE(HWFILE1/&FILE1) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(STP_END))
             DLTF       FILE(HWFILE1/&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(128) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) SRCFILE(FMTSRC) +
                          SRCMBR(AKBS20) OPTION(*NOPRT)

             OVRDBF     FILE(AKBWP202) TOFILE(HWFILE1/&FILE2)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          198) LPI(6) CPI(15) OVRFLW(62) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(AKBR21)
             DLTOVR     FILE(*ALL)
 STP_END:
             ENDPGM
