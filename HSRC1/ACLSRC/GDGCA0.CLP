             PGM
         /** GDGCA0 ***********************************************/
         /*   ASJ PASS-THROUGH PART SETTING NO. INC-DECREASE LIST */
         /*   CODING:K.OKACHI                    2000.11.09       */
         /*********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             DCL        VAR(&WS)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&REC)    TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&FILE1)  TYPE(*CHAR)  LEN(10)
             DCL        VAR(&FILE2)  TYPE(*CHAR)  LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)


             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE1)  VALUE('GDGWPA0' *CAT &WS)
             DLTF       FILE(&WLIB/&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE1) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(GDGWPA0) TOFILE(&WLIB/&FILE1)

             CALL       PGM(GDGRA0)

             CHGVAR     VAR(&REC) VALUE('0')
             RTVMBRD    FILE(&WLIB/&FILE1) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(END))
             CHGVAR     VAR(&FILE2)  VALUE('GDGWPA01' *CAT &WS)
             DLTF       FILE(&WLIB/&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE2) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             FMTDTA     INFILE((&WLIB/&FILE1)) +
                          OUTFILE(&WLIB/&FILE2) SRCFILE(FMTSRC) +
                          SRCMBR(GDGSA0) OPTION(*NOPRT)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 80) +
                          OVRFLW(62) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6S1) IGCDTA(&PIGCD)
             OVRDBF     FILE(GDGWPA01) TOFILE(&WLIB/&FILE2)
             CALL       PGM(GDGRA1) PARM(&USER)
             DLTF       FILE(&WLIB/&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)

 END:
             DLTOVR     FILE(*ALL)
             ENDPGM
