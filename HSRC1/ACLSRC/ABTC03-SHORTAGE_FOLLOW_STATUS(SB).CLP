             PGM
             /** ABTC03 **********************************************/
             /* SHORTAGE FOLLOW STATUS(SB)                           */
             /*    SAKAKI.          2019.10.31                       */
             /********************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ABTWP01) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABTWP02) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P1PG) TYPE(*DEC) LEN(05 0) VALUE(1)
             DCL        VAR(&P1CMD) TYPE(*CHAR) LEN(2)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&ABTWP01) VALUE('ABTWP01' *CAT &WS3)
             CHGVAR     VAR(&ABTWP02) VALUE('ABTWP02' *CAT &WS3)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

 STP00:
             DLTF       FILE(&WLIB/&ABTWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABTWP01) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABTWP01) OPTION(*NOLIST *NOSRC) +
                          SIZE(500000 1500 3) LVLCHK(*NO) AUT(*ALL)
             DLTF       FILE(&WLIB/&ABTWP02)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABTWP02) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABTWP02) OPTION(*NOLIST *NOSRC) +
                          SIZE(500000 1500 3) LVLCHK(*NO) AUT(*ALL)
             CHGVAR     VAR(&P1PG) VALUE(1)
 STP10:
             OVRDBF     FILE(ABTWP01) TOFILE(&WLIB/&ABTWP01)
             CALL       PGM(ABTR01)
 STP20:
             OVRDBF     FILE(ABTWP01) TOFILE(&WLIB/&ABTWP01)
             OVRDBF     FILE(ABTWP02) TOFILE(&WLIB/&ABTWP02)
             CALL       PGM(ABTR02) PARM('3')
 STP30:
             OVRDBF     FILE(ABTWP02) TOFILE(&WLIB/&ABTWP02)
             CALL       PGM(ABTR04) PARM('3' &P1PG &P1CMD)
             IF         COND(&P1CMD *EQ '01') THEN(GOTO CMDLBL(#END))
             IF         COND(&P1CMD *EQ '05') THEN(GOTO CMDLBL(STP00))
             IF         COND(&P1PG *EQ 1) THEN(GOTO CMDLBL(STP00))
             GOTO       CMDLBL(STP30)

 #END:       ENDPGM
