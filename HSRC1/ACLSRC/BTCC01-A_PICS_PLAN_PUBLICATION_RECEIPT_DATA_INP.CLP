             PGM
             /*** BTCC01 ***********************************/
             /* A-PICS PLAN PUBLICATION RECEIPT DATA INPUT */
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
             DCL        VAR(&BTCWP01) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BTCWP02) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             CHGVAR     VAR(&BTCWP01) VALUE('BTCWP01' *CAT &WS3)
             CHGVAR     VAR(&BTCWP02) VALUE('BTCWP02' *CAT &WS3)

             CHGJOB     OUTQ(&PRTG)

 #STP10:
             DLTF       FILE(&WLIB/&BTCWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&BTCWP01) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(BTCWP01) +
                          OPTION(*NOLIST *NOSRC) SIZE(500 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(BTCWP01) TOFILE(&WLIB/&BTCWP01)
             CALL       PGM(BTCR01) PARM(&PCMD)
             RTVMBRD    FILE(&WLIB/&BTCWP01) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             GOTO END
             ENDDO
 #STP20:
             DLTF       FILE(&WLIB/&BTCWP02)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&BTCWP02) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(BTCWP02) +
                          OPTION(*NOLIST *NOSRC) SIZE(500 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(BTCWP01) TOFILE(&WLIB/&BTCWP01)
             OVRDBF     FILE(BTCWP02) TOFILE(&WLIB/&BTCWP02)
             CALL       PGM(BTCR02)
             CALL       PGM(BTCR03)
             CALL       PGM(BTCR04)
             CALL       PGM(BTCR05)

 END:
             ENDPGM
