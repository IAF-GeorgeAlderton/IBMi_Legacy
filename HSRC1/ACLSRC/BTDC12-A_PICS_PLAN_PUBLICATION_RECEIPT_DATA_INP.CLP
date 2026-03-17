             PGM
             /*** BTDC12 ***********************************/
             /* PT PLAN PUBLICATION CSV DATA(MONTHLY SETTING) */
             /*   SAKAKI.          2019.09.11              */
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
             DCL        VAR(&BTDWP10) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BTDWP11) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BTDWP13) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BTDWP14) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MSGTXT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PMSG) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30) +
                          VALUE('PT PLAN CHANGE LIST')

             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CALL       PGM(ALBC01) PARM(&PPUSER &FLIB &WLIB)

             CHGVAR     VAR(&BTDWP10) VALUE('BTDWP10' *CAT &WS3)
             CHGVAR     VAR(&BTDWP11) VALUE('BTDWP11' *CAT &WS3)
             CHGVAR     VAR(&BTDWP13) VALUE('BTDWP13' *CAT &WS3)
             CHGVAR     VAR(&BTDWP14) VALUE('ABMWPBT' *CAT &WS3)


             CHGJOB     OUTQ(&PRTG)
 #STP10:
 #STP20:
             DLTF       FILE(&WLIB/&BTDWP10)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&BTDWP10) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(BTDWP10) +
                          OPTION(*NOLIST *NOSRC) SIZE(500 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             DLTF       FILE(&WLIB/&BTDWP11)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&BTDWP11) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(BTDWP11) +
                          OPTION(*NOLIST *NOSRC) SIZE(50000 5000 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(BTDWP11) TOFILE(&WLIB/&BTDWP11)
             OVRDBF     FILE(BTDWP10) TOFILE(&WLIB/&BTDWP10)
             CALL       PGM(BTDR16)
             RTVMBRD    FILE(&WLIB/&BTDWP11) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             GOTO       CMDLBL(#STP80)
             ENDDO
 #STP30:
             DLTF       FILE(&WLIB/&BTDWP13)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&BTDWP13) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(BTDWP13) +
                          OPTION(*NOLIST *NOSRC) SIZE(500 5000 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(BTDWP10) TOFILE(&WLIB/&BTDWP10)
             OVRDBF     FILE(BTDWP11) TOFILE(&WLIB/&BTDWP11)
             OVRDBF     FILE(BTDWP13) TOFILE(&WLIB/&BTDWP13)
             CALL       PGM(BTDR13)
 #STP40:
             DLTF       FILE(&WLIB/&BTDWP14)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&BTDWP14) RCDLEN(4096) +
                          OPTION(*NOLIST *NOSRC) SIZE(500 5000 3) +
                          LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(BTDWP13) TOFILE(&WLIB/&BTDWP13)
             OVRDBF     FILE(BTDWP14) TOFILE(&WLIB/&BTDWP14)
             CALL       PGM(BTDR14)

             CHGVAR     VAR(&BTDWP14) VALUE('ABMWPBT' *CAT &WS3)
             CALL       PGM(APLC96) PARM('1' &BTDWP14 &WLIB +
                          &FNAM 'Y' ' ')

 #STP80:
             GOTO       CMDLBL(END)
 #STP99:

 END:
             ENDPGM
