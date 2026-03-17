             PGM
             /*** MRHC13 ***********************************/
             /* PILOT LOCATION LIST                        */
             /*  TR-ITS            2014.05.16              */
             /**********************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&QPRT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&SLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&SFILE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P1DVKB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P1CMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MSGTXT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MRHWP13) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&SLIB)  VALUE('HSRC1')
             CHGVAR     VAR(&SFILE) VALUE('ADDSSRC')
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&MRHWP13) VALUE('MRHWP13' *CAT &WS3)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             CHGJOB     OUTQ(&PRTG)

 #STP00:
             CALL       PGM(MRHR13) PARM(&P1DVKB &P1CMD &QPRT)
             IF         COND(&P1CMD *EQ '01') THEN(GOTO CMDLBL(END))
 #STP10:
             DLTF       FILE(&WLIB/&MRHWP13)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&MRHWP13) +
                          SRCFILE(&SLIB/&SFILE) SRCMBR(MRHWP13) +
                          OPTION(*NOLIST *NOSRC) SIZE(500 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(MRHWP13) TOFILE(&WLIB/&MRHWP13)
             CALL       PGM(MRHR15) PARM(&P1DVKB &P1CMD)
             RTVMBRD    FILE(&WLIB/&MRHWP13) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&MSGTXT) VALUE('THERE ARE NO DATA (G)')
             CHGVAR     VAR(&PKINP) VALUE('G    ')
             CHGVAR     VAR(&PKOUT) VALUE(' ')
             CALL       PGM(APLR90) PARM(&MSGTXT &PKINP &WSID &PKOUT)
             GOTO       CMDLBL(END)
             ENDDO
 #STP20:
             CHGVAR     VAR(&PRTG) VALUE(&QPRT)
             CHGJOB     OUTQ(&PRTG)
             MONMSG     MSGID(CPF1336)
             OVRPRTF    FILE(MRHPR14) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(64) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(MRHR14)
             DLTOVR     FILE(MRHPR14)

 END:
             ENDPGM
