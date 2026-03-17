             PGM
             /** BADC01 **********************************/
             /* PRODUCTION REORDER AND OVER MADE DATA STATUS LIST */
             /*        E.KAWASHIMA 90.03.08              */
             /********************************** BADC01 **/
             DCLF       FILE(BADPW01)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WS) USER(&US)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WS &PDEVT &PIGCD)

 STP1:       SNDRCVF    DEV(&WS) RCDFMT(BADPW011)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN12) VALUE('0')
             CHGVAR     VAR(&IN13) VALUE('0')
             CHGVAR     VAR(&IN14) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         COND(&KBN *NE '1' *AND &KBN *NE '2' *AND &KBN +
                          *NE '3') THEN(DO)
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&ERR) VALUE('DATA INSTRUCTION ISN''T RIGHT.')
             GOTO       CMDLBL(STP1)
             ENDDO

  /*         IF         COND(&KOJO *NE '8982' *AND &KOJO *NE '8974' +
                          *AND &KOJO *NE '9032' *AND &KOJO *NE '9040' +
                          *AND &KOJO *NE '8990' *AND &KOJO *NE '8907' +
                          *AND &KOJO *NE '9999') THEN(DO)           */
             IF         COND(&KOJO *NE '0111' *AND &KOJO *NE '9999') +
                          THEN(DO)
             CHGVAR     VAR(&IN12) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&ERR) VALUE('FACTORY ISN''T RIGHT.')
             GOTO       CMDLBL(STP1)
             ENDDO

             IF         COND(&STHZ *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN13) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&ERR) VALUE('INPUT START DATE.')
             GOTO       STP1
             ENDDO

             IF         (%SST(&STHZ 1 4) *LT '1988') GOTO STP2
             IF         (%SST(&STHZ 5 2) *LT '01') GOTO STP2
             IF         (%SST(&STHZ 5 2) *GT '12') GOTO STP2
             IF         (%SST(&STHZ 7 2) *LT '01') GOTO STP2
             IF         (%SST(&STHZ 7 2) *GT '31') GOTO STP2
             GOTO       STP3
 STP2:       CHGVAR     VAR(&IN13) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&ERR) VALUE('DATE ISN''T RIGHT.')
             GOTO       STP1

 STP3:       IF         COND(&ENHZ *EQ ' ') THEN(DO)
             CHGVAR     VAR(&IN14) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&ERR) VALUE('INPUT EXIT DATE.')
             GOTO       STP1
             ENDDO

             IF         (%SST(&ENHZ 1 4) *LT '1988') GOTO STP4
             IF         (%SST(&ENHZ 5 2) *LT '01') GOTO STP4
             IF         (%SST(&ENHZ 5 2) *GT '12') GOTO STP4
             IF         (%SST(&ENHZ 7 2) *LT '01') GOTO STP4
             IF         (%SST(&ENHZ 7 2) *GT '31') GOTO STP4
             GOTO       STP5
 STP4:       CHGVAR     VAR(&IN14) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&ERR) VALUE('DATE ISN''T RIGHT.')
             GOTO       STP1

 STP5:       IF         COND(&STHZ *GT &ENHZ) THEN(DO)
             CHGVAR     VAR(&IN13) VALUE('1')
             CHGVAR     VAR(&IN14) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&ERR) VALUE('START DATE IS BIGGER THAN EXIT DATE.')
             GOTO       STP1
             ENDDO

             IF         (&IN05 *NE '1') GOTO STP1
/* PRTNT OUT */
             DLTF       FILE(HWFILE1/BADWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/BADWP01) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(100000 10000 3) +
                          LVLCHK(*NO) AUT(*ALL)

/* PUCK OUT  DATA || */
             CALL       PGM(BADR01) PARM(&KBN &KOJO &STHZ &ENHZ)

             IF         (%SWITCH(0XXXXXXX)) DO
             DLTF       FILE(BADWP01)
             GOTO       END
             ENDDO

             DLTF       FILE(BADWP02)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/BADWP02) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(100000 10000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/BADWP01)) +
                          OUTFILE(HWFILE1/BADWP02) SRCFILE(FMTSRC) +
                          SRCMBR(BADS01) OPTION(*NOPRT)
             DLTF       FILE(BADWP01)

             DLTF       FILE(BADWP03)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/BADWP03) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(100000 10000 3) +
                          LVLCHK(*NO) AUT(*ALL)
/* NUMBER OF SHEETS TOTAL */
             CALL       PGM(BADR03)

             DLTF       FILE(BADWP04)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/BADWP04) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(100000 10000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/BADWP03)) +
                          OUTFILE(HWFILE1/BADWP04) SRCFILE(FMTSRC) +
                          SRCMBR(BADS02) OPTION(*NOPRT)
             DLTF       FILE(BADWP03)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)

             CALL       PGM(BADR02) PARM(&KBN &KOJO &STHZ &ENHZ)

             DLTF       FILE(BADWP04)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM
