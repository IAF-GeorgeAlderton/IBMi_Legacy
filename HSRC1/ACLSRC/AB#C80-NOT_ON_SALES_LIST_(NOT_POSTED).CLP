             PGM
             /** AB#C80 ************************************/
             /* ..EDI FIXED ORDER DATA NOT ON SALES LIST.. */
             /*    K.OKACHI                    98.03.12    */
             /*                                            */
             /* TCHK1 03/27/07 CHG FOR CHECK               */
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
             DCL        VAR(&FILE2)  TYPE(*CHAR)  LEN(11)

    /*SEND MAIL SET */
             DCL        VAR(&TO1)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&SUB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FNAME)  TYPE(*CHAR) LEN(30)

             CHGVAR     VAR(&TO1) +
                          VALUE('ATSUO.MAMIYA@IAFI.COM')
             CHGVAR     VAR(&SUB) VALUE('SALES DATA')
             CHGVAR     VAR(&FNAME) VALUE('SALES-DATA.TXT')



             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE)  VALUE('AB#WP80' *CAT &WS)
             CHGVAR     VAR(&FILE1) VALUE('AB#WP81' *CAT &WS)
             CHGVAR     VAR(&FILE2) VALUE('AB#WP8Z' *CAT &WS)

             DLTF       FILE(&FILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(99999 3000) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AB#WP80) TOFILE(HWFILE1/&FILE)
             CALL       PGM(AB#R80)

             CHGVAR     VAR(&REC) VALUE('0')
             RTVMBRD    FILE(HWFILE1/&FILE) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(END))

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(99999 3000) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/&FILE)) +
                          OUTFILE(HWFILE1/&FILE1) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S80) +
                          OPTION(*NOPRT)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(LANPRT50) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(EPRINT1) +
                          FORMTYPE(K6H1) HOLD(*YES) IGCDTA(&PIGCD) +
                          /*JW*/
             OVRDBF     FILE(AB#WP81) TOFILE(HWFILE1/&FILE1)
             CALL       PGM(AB#R81)
             DLTF       FILE(&FILE1)

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(99999 3000) +
                          LVLCHK(*NO) AUT(*ALL)

  /*         CALL       PGM(APLC31) PARM('QPRINT     ' 'HWFILE1    ' +
                          &FILE2)                  */

  /*         CALL       PGM(APLC30) PARM(&TO1 &SUB 'HWFILE1' &FILE2 +
                          &FNAME)                  */



 END:        DLTOVR     FILE(*ALL)

/* TCHK1     DLTF       FILE(HWFILE1/&FILE)     */
/* TCHK1     MONMSG     MSGID(CPF3261 CPF2105)  */

             ENDPGM
