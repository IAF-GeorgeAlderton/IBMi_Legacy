             PGM
             /** AAIC31 **********************************/
             /* UPDATE PICKUP TIME CONTROL M/F           */
             /*    ITS           2012.11.05              */
             /********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&HSRC1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&PKOSN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PBMON) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&AAIWP31) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSNO) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSNO 1 3))
             CHGVAR     VAR(&AAIWP31) VALUE('AAIWP31' *CAT &WS)
             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

STP20:
             CALL       PGM(AAIR31) PARM(&PKOSN &PBMON &PCMD)
             IF         COND(&PCMD *EQ '01') THEN(GOTO CMDLBL(#END))
STP21:
             DLTF       FILE(&WLIB/&AAIWP31)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AAIWP31) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AAIWP31) +
                          OPTION(*NOLIST *NOSRC) SIZE(9999 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AAIWP31) TOFILE(&WLIB/&AAIWP31)
             CALL       PGM(AAIR32) PARM(&PKOSN &PBMON &PCMD)
STP22:
             OVRDBF     FILE(AAIWP31) TOFILE(&WLIB/&AAIWP31)
             CALL       PGM(AAIR33) PARM(&PKOSN &PBMON &PCMD)
             IF         COND(&PCMD *EQ '03') THEN(GOTO CMDLBL(STP20))
STP24:
             OVRDBF     FILE(AAIWP31) TOFILE(&WLIB/&AAIWP31)
             CALL       PGM(AAIR35) PARM(&PKOSN &PBMON &PCMD)
             GOTO       CMDLBL(STP20)

 #END:       ENDPGM
