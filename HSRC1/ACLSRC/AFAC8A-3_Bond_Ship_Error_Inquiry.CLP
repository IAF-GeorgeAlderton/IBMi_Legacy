             PGM
             /** AFAC8A *******************************/
             /* 3-BOND SHIP ERROR INQUIRY             */
             /*    ........  2017.12.14               */
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
             DCL        VAR(&P1COH1) TYPE(*CHAR) LEN(8)
             DCL        VAR(&P1COH2) TYPE(*CHAR) LEN(8)
             DCL        VAR(&P1COUS) TYPE(*CHAR) LEN(6)
             DCL        VAR(&P1HNTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&AFAWP8A) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P1LHN) TYPE(*CHAR) LEN(12)
             DCL        VAR(&P1DET1) TYPE(*CHAR) LEN(4)
             DCL        VAR(&P1DET2) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&AFAWP8A) VALUE('AFAWP8A' *CAT &WS3)

 #STP00:
             CALL       PGM(AFAR8A) PARM(&P1COH1 &P1COH2 &P1COUS +
                          &P1LHN &P1DET1 &P1DET2 &PCMD)
             IF         COND(&PCMD *EQ '03') THEN(GOTO CMDLBL(#END))
 #STP10:
             DLTF       FILE(HWFILE1/&AFAWP8A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&AFAWP8A) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AFAWP8A) +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 1000 +
                          3) LVLCHK(*NO) AUT(*ALL)
 #STP20:
             OVRDBF     FILE(AFAWP8A) TOFILE(HWFILE1/&AFAWP8A)
             CALL       PGM(AFAR8B) PARM(&P1COH1 &P1COH2 &P1COUS +
                          &P1LHN &P1DET1 &P1DET2 &PCMD)
 #STP30:
             OVRDBF     FILE(AFAWP8A) TOFILE(HWFILE1/&AFAWP8A)
             CALL       PGM(AFAR8C) PARM(&P1COH1 &P1COH2 &P1COUS +
                          &P1LHN &P1DET1 &P1DET2 &PCMD)
             GOTO       CMDLBL(#STP00)
 #STP80:
 #STP99:
 #END:
             ENDPGM
