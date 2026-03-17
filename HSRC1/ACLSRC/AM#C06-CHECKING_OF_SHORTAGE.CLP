             PGM        PARM(&WORKER &WUSRID)
             /** AM#C06 ************************/
             /* CHECKING OF SHORTAGE           */
             /*   ITS.             2015.06.08  */
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
             DCL        VAR(&AM#WP06) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P1TICK) TYPE(*CHAR) LEN(100)
             DCL        VAR(&MSGTXT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P1PPUL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WUSRID) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 4 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             CHGVAR     VAR(&AM#WP06) VALUE('AM#WP06' *CAT &WS3)
             CHGJOB     OUTQ(&PRTG)
 #STP10:
             CHGVAR     VAR(&P1PPUL) VALUE('0')
             CALL       PGM(AM#R0A) PARM(&WORKER &WUSRID &P1PPUL +
                          &P1TICK &PCMD)
             IF         COND(&PCMD *EQ '03') THEN(DO)
             GOTO       CMDLBL(END)
             ENDDO
 #STP20:
             DLTF       FILE(&WLIB/&AM#WP06)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AM#WP06) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AM#WP06) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AM#WP06) TOFILE(&WLIB/&AM#WP06)
             CALL       PGM(AM#R06) PARM(&P1TICK)
             RTVMBRD    FILE(&WLIB/&AM#WP06) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&MSGTXT) VALUE('THERE ARE NO INQ DATA (G)')
             CHGVAR     VAR(&PKINP) VALUE('G    ')
             CHGVAR     VAR(&PKOUT) VALUE(' ')
             CALL       PGM(APLR90) PARM(&MSGTXT &PKINP &WSID &PKOUT)
             GOTO       CMDLBL(END)
             ENDDO
 #STP30:
             OVRDBF     FILE(AM#WP06) TOFILE(&WLIB/&AM#WP06)
             CALL       PGM(AM#R07) PARM(&P1TICK)
             GOTO       CMDLBL(#STP10)
 #STP40:
 #STP50:
 END:
             ENDPGM
