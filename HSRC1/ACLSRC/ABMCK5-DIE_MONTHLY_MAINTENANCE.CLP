             PGM
             /** ABMCK5 ************************/
             /*金型必要数                    */
             /*   HOTTA.           2018.12.26  */
             /**********************************/
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
             DCL        VAR(&P@SORT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P@ERR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ABMWPK0) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWPK1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWPK2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(30)
             DCL        VAR(&P@SHN1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&P@SHN2) TYPE(*CHAR) LEN(5)
             DCL        VAR(&P@SHN3) TYPE(*CHAR) LEN(2)
             DCL        VAR(&P@GEKN) TYPE(*DEC) LEN(9 0)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO
             CHGVAR     VAR(&ABMWPK0) VALUE('ABMWPK0' *CAT &WS3)
             CHGVAR     VAR(&ABMWPK1) VALUE('ABMWPK1' *CAT &WS3)
             CHGVAR     VAR(&ABMWPK2) VALUE('ABMWPK2' *CAT &WS3)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
 STP00:
             CALL       PGM(ABMRK5) PARM(&P@SHN1 &P@SHN2 &P@SHN3 +
                          &P@GEKN &PCMD)
             IF         COND(&PCMD *EQ '01') THEN(GOTO CMDLBL(#END))
 STP10:
             DLTF       FILE(&WLIB/&ABMWPK0)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWPK0) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABMWPK0) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(ABMWPK0) TOFILE(&WLIB/&ABMWPK0)
             CALL       PGM(ABMRK6) PARM(&P@SHN1 &P@SHN2 &P@SHN3 +
                          &P@GEKN)

             DLTF       FILE(&WLIB/&ABMWPK1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWPK1) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABMWPK1) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(ABMWPK0) TOFILE(&WLIB/&ABMWPK0)
             OVRDBF     FILE(ABMWPK1) TOFILE(&WLIB/&ABMWPK1)
             CALL       PGM(ABMRK1)

             DLTF       FILE(&WLIB/&ABMWPK2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWPK2) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABMWPK2) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(ABMWPK1) TOFILE(&WLIB/&ABMWPK1)
             OVRDBF     FILE(ABMWPK2) TOFILE(&WLIB/&ABMWPK2)
             CALL       PGM(ABMRK2) PARM(&P@SORT)

         /*画面*/
             OVRDBF     FILE(ABMWPK2) TOFILE(&WLIB/&ABMWPK2)
             CALL       PGM(ABMRK3)
             GOTO       CMDLBL(STP00)

 #END:
 END:        ENDPGM
