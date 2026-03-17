             PGM
             /*** AAFC70 ***********************************/
             /* KANBAN LIST BY LINE AND SECTION*/
             /*           H.ITO          88.02.25          */
             /*********************************** AAFC70 ***/
             DCLF       FILE(AAFPW70)
/* ??**/     DCL        VAR(&MCEDP01) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PYM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRAIN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE1) VALUE('AAFWP70' *CAT &WS)
             CHGVAR     VAR(&FILE2) VALUE('AAFWP71' *CAT &WS)
             CHGJOB     RUNPTY(40) SWS(00000000)
             CHGVAR     VAR(&PYM) VALUE(%SUBSTRING(&MCEDP01 1 6))

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AAFPW701)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&PBMON = '    ') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT  SECTION CODE.')
             GOTO STP1
             ENDDO

             IF         ((&PKUBN *NE '1') *AND (&PKUBN *NE '2')) DO
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('SECTION CODE TYPE IS <1.+
                          2>')
             GOTO STP1
             ENDDO

             IF         (&IN05 *EQ '0') GOTO STP1

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(80) +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO) +
                          AUT(*ALL)

             OVRDBF     FILE(AAFWP70) TOFILE(&FILE1)
             CALL       PGM(AAFR70) PARM(&PBMON &PKUBN &PRAIN)
             CALL       PGM(AAFR71) PARM(&PBMON &PKUBN &PRAIN)

             IF         (%SWITCH(0XXXXXXX)) DO
             DLTF       FILE(&FILE1)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THERE ARE NOT DATA TO OUTPUT +
                          ')
             GOTO STP1
             ENDDO

             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(80) +
                          OPTION(*NOLIST) SIZE(2000) LVLCHK(*NO) +
                          AUT(*ALL)
             FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) SRCFILE(FMTSRC) +
                          SRCMBR(AAFS70) OPTION(*NOPRT)
             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF2103)

             OVRPRTF    FILE(QPRINT2) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(62) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             OVRDBF     FILE(AAFWP71) TOFILE(&FILE2)
             CALL       PGM(AAFR72) PARM(&PYM &USER &PBMON)
             DLTF       FILE(&FILE2)
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF2128)

 END:        CHGJOB     RUNPTY(20)

             ENDPGM
