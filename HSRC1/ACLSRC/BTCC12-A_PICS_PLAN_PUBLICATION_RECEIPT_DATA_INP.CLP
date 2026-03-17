             PGM
             /*** BTCC11 ***********************************/
             /* A-PICS PLAN PUBLICATION CSV DATA           */
             /*  ITS.              2013.11.14              */
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
             DCL        VAR(&BTCWP10) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BTCWP11) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BTCWP13) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BTCWP14) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MSGTXT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PMSG) TYPE(*CHAR) LEN(256)
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

             CHGVAR     VAR(&BTCWP10) VALUE('BTCWP10' *CAT &WS3)
             CHGVAR     VAR(&BTCWP11) VALUE('BTCWP11' *CAT &WS3)
             CHGVAR     VAR(&BTCWP13) VALUE('BTCWP13' *CAT &WS3)
             CHGVAR     VAR(&BTCWP14) VALUE('BTCWP14')

             CRTDTAARA  DTAARA(&WLIB/BTCC12ACT) TYPE(*CHAR) LEN(1)
             MONMSG     MSGID(CPF1023) EXEC(GOTO CMDLBL(#STP99))

             CHGJOB     OUTQ(&PRTG)

 #STP10:
             CALL       PGM(BTCR11) PARM(&PCMD)
             IF         COND(&PCMD *EQ '01') THEN(DO)
             GOTO       CMDLBL(#STP80)
             ENDDO
 #STP20:
             DLTF       FILE(&WLIB/&BTCWP10)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&BTCWP10) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(BTCWP10) +
                          OPTION(*NOLIST *NOSRC) SIZE(500 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             DLTF       FILE(&WLIB/&BTCWP11)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&BTCWP11) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(BTCWP11) +
                          OPTION(*NOLIST *NOSRC) SIZE(50000 5000 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(BTCWP11) TOFILE(&WLIB/&BTCWP11)
             OVRDBF     FILE(BTCWP10) TOFILE(&WLIB/&BTCWP10)
             CALL       PGM(BTCR16)
             RTVMBRD    FILE(&WLIB/&BTCWP11) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&MSGTXT) VALUE('THERE ARE NO DATA (G)')
             CHGVAR     VAR(&PKINP) VALUE('G    ')
             CHGVAR     VAR(&PKOUT) VALUE(' ')
             CALL       PGM(APLR90) PARM(&MSGTXT &PKINP &WSID &PKOUT)
             IF         COND(&PKOUT *EQ 'G') THEN(GOTO CMDLBL(#STP80))
             ENDDO
 #STP30:
             DLTF       FILE(&WLIB/&BTCWP13)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&BTCWP13) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(BTCWP13) +
                          OPTION(*NOLIST *NOSRC) SIZE(500 5000 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(BTCWP10) TOFILE(&WLIB/&BTCWP10)
             OVRDBF     FILE(BTCWP11) TOFILE(&WLIB/&BTCWP11)
             OVRDBF     FILE(BTCWP13) TOFILE(&WLIB/&BTCWP13)
             CALL       PGM(BTCR13)
 #STP40:
             DLTF       FILE(&WLIB/&BTCWP14)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&BTCWP14) RCDLEN(2048) +
                          OPTION(*NOLIST *NOSRC) SIZE(500 5000 3) +
                          LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(BTCWP13) TOFILE(&WLIB/&BTCWP13)
             OVRDBF     FILE(BTCWP14) TOFILE(&WLIB/&BTCWP14)
             CALL       PGM(BTCR14)
 #STP80:
             DLTDTAARA  DTAARA(&WLIB/BTCC12ACT)
             GOTO       CMDLBL(END)
 #STP99:
             CHGVAR     VAR(&MSGTXT) VALUE('SOMEONE ELSE USING THIS +
                          MENU.WAIT FOR A WHILE. ENTER G TO EXIT. +
                          (BTCC12)')
             CHGVAR     VAR(&PKINP) VALUE('G    ')
             CHGVAR     VAR(&PKOUT) VALUE(' ')
             CALL       PGM(APLR90) PARM(&MSGTXT &PKINP &WSID &PKOUT)

 END:
             ENDPGM
