             PGM
             /** AGLC00 **********************************************/
             /*平準化　箱数変更履歴照会                            */
             /*    KATOGI.          2016.01.19                       */
             /********************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
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
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PCR1) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PCR2) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PCB1) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PCB2) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&AGLWP00) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PSHN1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PSHN2) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PSHN3) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PTBOX) TYPE(*DEC) LEN(10 2)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&AGLWP00) VALUE('AGLWP00' *CAT &WS3)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO
 STP10:
             CALL       PGM(AGLR00) PARM(&PCR1 &PCB1 &PCR2 &PCB2 +
                          &PSHN1 &PSHN2 &PSHN3 &PCMD)
             IF         COND(&PCMD *EQ '01') THEN(GOTO CMDLBL(#END))
 STPA1:
             DLTF       FILE(&WLIB/&AGLWP00)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AGLWP00) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AGLWP00) OPTION(*NOLIST *NOSRC) +
                          SIZE(500000 1500 3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AGLWP00) TOFILE(&WLIB/&AGLWP00)
             CALL       PGM(AGLR01) PARM(&PCR1 &PCB1 &PCR2 &PCB2 +
                          &PSHN1 &PSHN2 &PSHN3 &PCMD)
             OVRDBF     FILE(AGLWP00) TOFILE(&WLIB/&AGLWP00)
             CALL       PGM(AGLR02) PARM(&PCR1 &PCB1 &PCR2 &PCB2 +
                          &PSHN1 &PSHN2 &PSHN3 &PCMD)
             GOTO       CMDLBL(STP10)

 #END:       ENDPGM
