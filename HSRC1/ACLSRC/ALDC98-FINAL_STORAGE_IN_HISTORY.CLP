             PGM
             /** ALDC98 *******************************/
             /* FINAL STORAGE IN HISTORY              */
             /*    ........  2015.10.07               */
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
             DCL        VAR(&ALDWP98) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P1LHN) TYPE(*CHAR) LEN(12)
             DCL        VAR(&P1DET1) TYPE(*CHAR) LEN(4)
             DCL        VAR(&P1DET2) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&ALDWP98) VALUE('ALDWP98' *CAT &WS3)

 #STP00:
             CALL       PGM(ALDR9A) PARM(&P1MTK1 &P1MTK2 &P1MTK3 +
                          &P1MTK4 &P1MT21 &P1MT22 &P1MT23 &P1MT24 +
                          &P1COH1 &P1COH2 &P1COUS &P1HNTE &P1LHN +
                          &P1DET1 &P1DET2 &PCMD)
             IF         COND(&PCMD *EQ '03') THEN(GOTO CMDLBL(#END))
 #STP10:
             DLTF       FILE(HWFILE1/&ALDWP98)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&ALDWP98) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(ALDWP98) +
                          OPTION(*NOLIST *NOSRC) SIZE(9999999 10000 +
                          3) LVLCHK(*NO) AUT(*ALL)
 #STP20:
             OVRDBF     FILE(ALDWP98) TOFILE(HWFILE1/&ALDWP98)
             CALL       PGM(ALDR9B) PARM(&P1MTK1 &P1MTK2 &P1MTK3 +
                          &P1MTK4 &P1MT21 &P1MT22 &P1MT23 &P1MT24 +
                          &P1COH1 &P1COH2 &P1COUS &P1HNTE &P1LHN +
                          &P1DET1 &P1DET2 &PCMD)
 #STP30:
             OVRDBF     FILE(ALDWP98) TOFILE(HWFILE1/&ALDWP98)
             CALL       PGM(ALDR9C) PARM(&P1MTK1 &P1MTK2 &P1MTK3 +
                          &P1MTK4 &P1MT21 &P1MT22 &P1MT23 &P1MT24 +
                          &P1COH1 &P1COH2 &P1COUS &P1HNTE &P1LHN +
                          &P1DET1 &P1DET2 &PCMD)
             GOTO       CMDLBL(#STP00)
 #STP80:
 #STP99:
 #END:
             ENDPGM
