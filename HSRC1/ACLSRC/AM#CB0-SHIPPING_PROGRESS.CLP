             PGM
             /*** AM#CB0 ***********************************/
             /* SHIPPING PROGRESS                          */
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
             DCL        VAR(&AM#WPB1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AM#WPB3) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P1SHID) TYPE(*CHAR) LEN(8)
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

             CHGVAR     VAR(&AM#WPB1) VALUE('AM#WPB1' *CAT &WS3)
             CHGVAR     VAR(&AM#WPB3) VALUE('AM#WPB3' *CAT &WS3)

             CHGJOB     OUTQ(&PRTG)
 #STP00:
             CALL       PGM(AM#RB0) PARM(&P1SHID &PCMD)
             IF         COND(&PCMD *EQ '01') THEN(DO)
             GOTO       CMDLBL(END)
             ENDDO
 #STP10:
             DLTF       FILE(&WLIB/&AM#WPB1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AM#WPB1) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AM#WPB1) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 10) LVLCHK(*NO) AUT(*ALL)
             DLTF       FILE(&WLIB/&AM#WPB3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AM#WPB3) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AM#WPB3) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 10) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AM#WPB1) TOFILE(&WLIB/&AM#WPB1)
             OVRDBF     FILE(AM#WPB3) TOFILE(&WLIB/&AM#WPB3)
             CALL       PGM(AM#RB1) PARM(&P1SHID)
             RTVMBRD    FILE(&WLIB/&AM#WPB1) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&MSGTXT) VALUE('THERE ARE NO INQ DATA (G)')
             CHGVAR     VAR(&PKINP) VALUE('G    ')
             CHGVAR     VAR(&PKOUT) VALUE(' ')
             CALL       PGM(APLR90) PARM(&MSGTXT &PKINP &WSID &PKOUT)
             GOTO       CMDLBL(#STP00)
             ENDDO
 #STP15:
             OVRDBF     FILE(AM#WPB1) TOFILE(&WLIB/&AM#WPB1)
             OVRDBF     FILE(AM#WPB3) TOFILE(&WLIB/&AM#WPB3)
             CALL       PGM(AM#RB4)
 #STP17:
             OVRDBF     FILE(AM#WPB1) TOFILE(&WLIB/&AM#WPB1)
             CALL       PGM(AM#RB6)
 #STP20:
             OVRDBF     FILE(AM#WPB1) TOFILE(&WLIB/&AM#WPB1)
             CALL       PGM(AM#RB2) PARM(&P1SHID &PCMD)
             IF         COND(&PCMD *EQ '03') THEN(DO)
             GOTO       CMDLBL(#STP00)
             ENDDO
             IF         COND(&PCMD *EQ '05') THEN(DO)
             GOTO       CMDLBL(#STP10)
             ENDDO
 #STP30:
 #STP40:
 #STP50:
 END:
             ENDPGM
