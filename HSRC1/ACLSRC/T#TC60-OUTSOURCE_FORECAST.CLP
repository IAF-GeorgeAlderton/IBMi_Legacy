             PGM
             /*** T#TC60 ***********************************/
             /* OUTSOURCE FORECAST                         */
             /*  ITS.              2015.07.16              */
             /**********************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&T#TWP61) TYPE(*CHAR) LEN(10)
             DCL        VAR(&T#TWP62) TYPE(*CHAR) LEN(10)
             DCL        VAR(&T#TWP63) TYPE(*CHAR) LEN(10)
             DCL        VAR(&T#TWP64) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P1BMON) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&P1SORT) TYPE(*CHAR) STG(*AUTO) LEN(1)
             DCL        VAR(&P1DAYS) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&MSGTXT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             CHGVAR     VAR(&T#TWP61) VALUE('T#TWP61' *CAT &WS3)
             CHGVAR     VAR(&T#TWP62) VALUE('T#TWP62' *CAT &WS3)
             CHGVAR     VAR(&T#TWP63) VALUE('T#TWP63' *CAT &WS3)
             CHGVAR     VAR(&T#TWP64) VALUE('T#TWP64' *CAT &WS3)

             CHGJOB     OUTQ(&PRTG)

 #STP00:
             CALL       PGM(T#TR60) PARM(&P1BMON &P1SORT &P1DAYS &PCMD)
             IF         COND(&PCMD *EQ '01') THEN(DO)
             GOTO       CMDLBL(END)
             ENDDO
 #STP10:
             DLTF       FILE(&WLIB/&T#TWP61)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&T#TWP61) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(T#TWP61) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 10) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(T#TWP61) TOFILE(&WLIB/&T#TWP61)
             CALL       PGM(T#TR61) PARM(&P1BMON &PCMD)
             RTVMBRD    FILE(&WLIB/&T#TWP61) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&MSGTXT) VALUE('THERE ARE NO INQ DATA (G)')
             CHGVAR     VAR(&PKINP) VALUE('G    ')
             CHGVAR     VAR(&PKOUT) VALUE(' ')
             CALL       PGM(APLR90) PARM(&MSGTXT &PKINP &WSID &PKOUT)
             GOTO       CMDLBL(#STP00)
             ENDDO
 #STP20:
             DLTF       FILE(&WLIB/&T#TWP62)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&T#TWP62) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(T#TWP62) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 10) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&WLIB/&T#TWP63)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&T#TWP63) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(T#TWP63) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 10) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(T#TWP61) TOFILE(&WLIB/&T#TWP61)
             OVRDBF     FILE(T#TWP62) TOFILE(&WLIB/&T#TWP62)
             OVRDBF     FILE(T#TWP63) TOFILE(&WLIB/&T#TWP63)
             CALL       PGM(T#TR62) PARM(&P1BMON &P1SORT &P1DAYS &PCMD)
             CALL       PGM(T#TR63) PARM(&P1BMON &PCMD)
 #STP30:
             DLTF       FILE(&WLIB/&T#TWP64)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&T#TWP64) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(T#TWP64) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 10) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(T#TWP62) TOFILE(&WLIB/&T#TWP62)
             OVRDBF     FILE(T#TWP63) TOFILE(&WLIB/&T#TWP63)
             OVRDBF     FILE(T#TWP64) TOFILE(&WLIB/&T#TWP64)
             CALL       PGM(T#TR64) PARM(&P1BMON &PCMD)
 #STP40:
             OVRDBF     FILE(T#TWP62) TOFILE(&WLIB/&T#TWP62)
             OVRDBF     FILE(T#TWP64) TOFILE(&WLIB/&T#TWP64)
             CALL       PGM(T#TR65) PARM(&P1BMON &P1SORT &P1DAYS &PCMD)
             GOTO       CMDLBL(#STP00)
 #STP50:
 END:
             ENDPGM
