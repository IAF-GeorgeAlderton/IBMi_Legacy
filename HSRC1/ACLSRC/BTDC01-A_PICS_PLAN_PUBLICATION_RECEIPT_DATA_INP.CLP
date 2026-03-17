             PGM
             /*** BTDC01 ***********************************/
             /* PT PLAN PUBLICATION DATA(MONTHLY SETTING)  */
             /*    SAKAKI.      2019.09.11                 */
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
             DCL        VAR(&BTDWP01) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BTDWP02) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BTDWP0E) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(30)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             CHGVAR     VAR(&BTDWP01) VALUE('BTDWP01' *CAT &WS3)
             CHGVAR     VAR(&BTDWP02) VALUE('BTDWP02' *CAT &WS3)
             CHGVAR     VAR(&BTDWP0E) VALUE('ABMWP@E')
             CHGVAR     VAR(&FNAM) VALUE('PT ORDER STOP CHECK LIST')

             CHGJOB     OUTQ(&PRTG)

 #STP10:
             DLTF       FILE(&WLIB/&BTDWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&BTDWP01) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(BTDWP01) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 3) LVLCHK(*NO) AUT(*ALL)
             DLTF       FILE(&WLIB/&BTDWP0E)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&BTDWP0E) RCDLEN(0256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             OVRDBF     FILE(BTDWP01) TOFILE(&WLIB/&BTDWP01)
             OVRDBF     FILE(BTDWP0E) TOFILE(&WLIB/&BTDWP0E)
             CALL       PGM(BTDR01)
             RTVMBRD    FILE(&WLIB/&BTDWP0E) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)
             CALL       PGM(APLC96) PARM('1' &BTDWP0E &WLIB +
                          &FNAM 'Y' ' ')
             ENDDO
             RTVMBRD    FILE(&WLIB/&BTDWP01) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             GOTO END
             ENDDO
 #STP20:
             DLTF       FILE(&WLIB/&BTDWP02)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&BTDWP02) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(BTDWP02) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(BTDWP01) TOFILE(&WLIB/&BTDWP01)
             OVRDBF     FILE(BTDWP02) TOFILE(&WLIB/&BTDWP02)
             CALL       PGM(BTDR02)
             CALL       PGM(BTDR03)
             CALL       PGM(BTDR04)
             CALL       PGM(BTDR05)

 END:
             ENDPGM
