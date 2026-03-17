             PGM
             /** AL#CB5 ************************/
             /* CHECKING OF SH PROCESS(INPUT)  */
             /*   ITS.             2015.06.02  */
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
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&AL#WPB6) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P1SHME) TYPE(*CHAR) LEN(20)
             DCL        VAR(&P1FIXD) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&P1IAFB) TYPE(*CHAR) LEN(3)
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

             CHGVAR     VAR(&AL#WPB6) VALUE('AL#WPB6' *CAT &WS3)
             CHGJOB     OUTQ(&PRTG)
 #STP10:
             CALL       PGM(AL#RB5) PARM(&P1FIXD &P1IAFB &PCMD)
             IF         COND(&PCMD *EQ '01') THEN(DO)
             GOTO       CMDLBL(END)
             ENDDO
 #STP20:
             DLTF       FILE(&WLIB/&AL#WPB6)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AL#WPB6) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AL#WPB6) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AL#WPB6) TOFILE(&WLIB/&AL#WPB6)
             CALL       PGM(AL#RB6) PARM(&P1FIXD &P1IAFB &PCMD)
             RTVMBRD    FILE(&WLIB/&AL#WPB6) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&MSGTXT) VALUE('THERE ARE NO INQ DATA (G)')
             CHGVAR     VAR(&PKINP) VALUE('G    ')
             CHGVAR     VAR(&PKOUT) VALUE(' ')
             CALL       PGM(APLR90) PARM(&MSGTXT &PKINP &WSID &PKOUT)
             GOTO       CMDLBL(#STP10)
             ENDDO
 #STP30:
             OVRDBF     FILE(AL#WPB6) TOFILE(&WLIB/&AL#WPB6)
             CALL       PGM(AL#RB7)
 #STP40:
 #STP50:
 END:
             ENDPGM
