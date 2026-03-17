             PGM        PARM(&P@NTYM &PRTG@)
             /** ABMC54 ************************/
             /* NO PART M/F LIST               */
             /*   HOTTA.           2018.10.16  */
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
             DCL        VAR(&P@NTYM) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&P@ERR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ABMWP54) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWP56) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30) VALUE('NO +
                          PART MF LIST')
             DCL        VAR(&PRTG@) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO
             CHGVAR     VAR(&ABMWP54) VALUE('ABMWP54' *CAT &WS3)
             CHGVAR     VAR(&ABMWP56) VALUE('ABMWP56')

 STP10:
         /*部品Ｍなしリスト*/
             DLTF       FILE(&WLIB/&ABMWP54)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWP54) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABMWP54) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(ABMWP54) TOFILE(&WLIB/&ABMWP54)
             CALL       PGM(ABMR54) PARM(&P@NTYM)

             OVRPRTF    FILE(ABMPR55) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG@) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(ABMR55)

             DLTF       FILE(&ABMWP56)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWP56) RCDLEN(0256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             OVRDBF     FILE(ABMWP54) TOFILE(&WLIB/&ABMWP54)
             OVRDBF     FILE(ABMWP56) TOFILE(&WLIB/&ABMWP56)
             CALL       PGM(ABMR56)

             CALL       PGM(APLC96) PARM('1' &ABMWP56 &WLIB +
                          &FNAM 'Y' ' ')

 #END:
 END:        ENDPGM
