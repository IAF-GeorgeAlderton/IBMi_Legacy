             PGM
             /** BSCC55 *******************************/
             /* FINAL STORAGE IN   HISTORY            */
             /*    ITS.      2014.09.22               */
             /*****************************************/
             DCL        VAR(&P1SEL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&RETRY) TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&IAFFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&IAFSRC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&IAFWFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P1MTK1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P1MTK2) TYPE(*CHAR) LEN(2)
             DCL        VAR(&P1MTK3) TYPE(*CHAR) LEN(2)
             DCL        VAR(&P1MTK4) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P1MT21) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P1MT22) TYPE(*CHAR) LEN(2)
             DCL        VAR(&P1MT23) TYPE(*CHAR) LEN(2)
             DCL        VAR(&P1MT24) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P1COH1) TYPE(*CHAR) LEN(8)
             DCL        VAR(&P1COH2) TYPE(*CHAR) LEN(8)
             DCL        VAR(&P1COUS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P1HNTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BSCWP55) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&BSCWP55) VALUE('BSCWP55' *CAT &WS3)

 #STP00:
             CALL       PGM(BSCR55) PARM(&P1MTK1 &P1MTK2 &P1MTK3 +
                          &P1MTK4 &P1MT21 &P1MT22 &P1MT23 &P1MT24 +
                          &P1COH1 &P1COH2 &P1COUS &P1HNTE &PCMD)
             IF         COND(&PCMD *EQ '03') THEN(GOTO CMDLBL(#END))
 #STP10:
             DLTF       FILE(HWFILE1/&BSCWP55)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&BSCWP55) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(BSCWP55) +
                          OPTION(*NOLIST *NOSRC) SIZE(1500000 1000 +
                          3) LVLCHK(*NO) AUT(*ALL)
 #STP20:
             OVRDBF     FILE(BSCWP55) TOFILE(HWFILE1/&BSCWP55)
             CALL       PGM(BSCR56) PARM(&P1MTK1 &P1MTK2 &P1MTK3 +
                          &P1MTK4 &P1MT21 &P1MT22 &P1MT23 &P1MT24 +
                          &P1COH1 &P1COH2 &P1COUS &P1HNTE &PCMD)
 #STP30:
             OVRDBF     FILE(BSCWP55) TOFILE(HWFILE1/&BSCWP55)
             CALL       PGM(BSCR57) PARM(&P1MTK1 &P1MTK2 &P1MTK3 +
                          &P1MTK4 &P1MT21 &P1MT22 &P1MT23 &P1MT24 +
                          &P1COH1 &P1COH2 &P1COUS &P1HNTE &PCMD)
             GOTO       CMDLBL(#STP00)
 #STP80:
 #STP99:
 #END:
             ENDPGM
