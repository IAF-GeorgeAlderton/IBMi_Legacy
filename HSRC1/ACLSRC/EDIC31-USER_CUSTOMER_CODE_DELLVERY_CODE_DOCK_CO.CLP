             PGM
             /** EDIC31 ************************************/
             /* USER CUSTOMER CODE DELLVERY CODE DOCK CODE */
             /* TO IN-HOUSE CODE CONVERSION                */
             /*       CREATE DATE : 1998.02.10             */
             /*       CODING      : K.OKACHI.              */
             /**********************************************/
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             DCL        VAR(&WS)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&REC)    TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&FILE)  TYPE(*CHAR)  LEN(9)
             DCL        VAR(&FILE1)  TYPE(*CHAR)  LEN(9)

             RTVJOBA    JOB(&WSID)   USER(&US)
             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE)  VALUE('EDIWP31' *CAT &WS)
             CHGVAR     VAR(&FILE1) VALUE('EDIWP32' *CAT &WS)

             DLTF       FILE(HWFILE1/&FILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(EDIWP31) TOFILE(HWFILE1/&FILE)

             CALL       PGM(EDIR31)

             CHGVAR     VAR(&REC) VALUE('0')
             RTVMBRD    FILE(HWFILE1/&FILE) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(END))

           OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD)
 /*  AS400 NO.3 TEST */
 /*          OVRPRTF    FILE(QPRINT) DEVTYPE(*SCS) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1)               */

             DLTF       FILE(HWFILE1/&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/&FILE)) +
                          OUTFILE(HWFILE1/&FILE1) SRCFILE(FMTSRC) +
                          SRCMBR(EDIS31) OPTION(*NOPRT)

             OVRDBF     FILE(EDIWP32) TOFILE(HWFILE1/&FILE1)
             CALL       PGM(EDIR32)

             DLTF       FILE(HWFILE1/&FILE)
             MONMSG     MSGID(CPF3261 CPF2105)

 END:        DLTOVR     FILE(*ALL)
             ENDPGM
