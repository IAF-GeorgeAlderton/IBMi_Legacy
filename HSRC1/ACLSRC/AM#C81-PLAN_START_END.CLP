             PGM        PARM(&P1FIXD &P1FIXT &P1SHID &P1BINS)
             /*** AM#C81 ***********************************/
             /* PLAN START END                             */
             /*  ITS.              2015.06.22              */
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
             DCL        VAR(&AM#WP80) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AM#WP83) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AM#WP86) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P1SHID) TYPE(*CHAR) LEN(8)
             DCL        VAR(&P1FIXD) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&P1FIXT) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&P1BINS) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&P1KENS) TYPE(*DEC) LEN(4 0)
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

             CHGVAR     VAR(&AM#WP80) VALUE('AM#WP80' *CAT &WS3)
             CHGVAR     VAR(&AM#WP83) VALUE('AM#WP83' *CAT &WS3)
             CHGVAR     VAR(&AM#WP86) VALUE('AM#WP86' *CAT &WS3)

             CHGJOB     OUTQ(&PRTG)

 #STP00:
             DLTF       FILE(&WLIB/&AM#WP80)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AM#WP80) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AM#WP80) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 10) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AM#WP80) TOFILE(&WLIB/&AM#WP80)
             CALL       PGM(AM#R80) PARM(&P1FIXD &P1FIXT &P1SHID)
 #STP10:
             OVRDBF     FILE(AM#WP80) TOFILE(&WLIB/&AM#WP80)
             CALL       PGM(AM#R82)
 #STP20:
             DLTF       FILE(&WLIB/&AM#WP83)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AM#WP83) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AM#WP83) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 10) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AM#WP80) TOFILE(&WLIB/&AM#WP80)
             OVRDBF     FILE(AM#WP83) TOFILE(&WLIB/&AM#WP83)
 /*          CALL       PGM(AM#R83) PARM(&P1KENS)         */
             CALL       PGM(AM#R83)
 #STP30:
             DLTF       FILE(&WLIB/&AM#WP86)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AM#WP86) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AM#WP86) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 10) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AM#WP83) TOFILE(&WLIB/&AM#WP83)
             OVRDBF     FILE(AM#WP86) TOFILE(&WLIB/&AM#WP86)
             CALL       PGM(AM#R86) PARM(&P1FIXD &P1FIXT &P1BINS +
                          &P1KENS)
 #STP40:
             CALL       PGM(AM#R87) PARM(&P1FIXD &P1FIXT)
 #STP50:
 END:
             ENDPGM
