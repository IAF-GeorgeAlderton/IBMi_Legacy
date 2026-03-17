             PGM
             /** AB#C80 ************************************/
             /* ..EDI FIXED ORDER DATA NOT ON SALES LIST.. */
             /*    K.OKACHI                    98.03.12    */
             /************************************ AB#C80 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             DCL        VAR(&WS)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&REC)    TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&FILE)  TYPE(*CHAR)  LEN(9)
             DCL        VAR(&FILE1)  TYPE(*CHAR)  LEN(9)

             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE)  VALUE('AB#WP80' *CAT &WS)
             CHGVAR     VAR(&FILE1) VALUE('AB#WP81' *CAT &WS)

             OVRPRTF    FILE(QPRINT) OUTQ(LANPRT50) FORMTYPE(K6H1)
             OVRPRTF    FILE(QPRINT) OUTQ(EPRINT1) FORMTYPE(K6H1) +
                          HOLD(*YES) /*JW*/
             DLTF       FILE(&FILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(99999 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AB#WP80) TOFILE(HWFILE1/&FILE)
             CALL       PGM(AB#R82)

             CHGVAR     VAR(&REC) VALUE('0')
             RTVMBRD    FILE(HWFILE1/&FILE) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(END))

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(99999 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/&FILE)) +
                          OUTFILE(HWFILE1/&FILE1) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S80) +
                          OPTION(*NOPRT)

             OVRDBF     FILE(AB#WP81) TOFILE(HWFILE1/&FILE1)
             CALL       PGM(AB#R81)
             DLTF       FILE(&FILE1)

 END:

             DLTF       FILE(HWFILE1/&FILE)
             MONMSG     MSGID(CPF3261 CPF2105)

 /* ASN CHECK LIST */
             CALL       PGM(AB#R7Z)
             DLTOVR     FILE(*ALL)

             ENDPGM
