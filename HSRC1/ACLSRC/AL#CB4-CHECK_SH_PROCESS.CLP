             PGM        PARM(&#@OUTQ &P1IAFB &P1IAFP)
             /*** AL#CB4 ***********************************/
             /* CHECKING OF SH PROCESS                     */
             /*  ITS.              2015.06.02              */
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
             DCL        VAR(&AL#WPB1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&#@OUTQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P1IAFB) TYPE(*CHAR) LEN(03)
             DCL        VAR(&P1IAFP) TYPE(*CHAR) LEN(03)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             CHGVAR     VAR(&AL#WPB1) VALUE('AL#WPB1' *CAT &WS3)
             CHGJOB     OUTQ(&PRTG)
 #STP10:
 #STP20:
 #STP30:
             OVRDBF     FILE(AL#WPB1) TOFILE(&WLIB/&AL#WPB1)
             OVRPRTF    FILE(AL#PRB4) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(&#@OUTQ) FORMTYPE(K6H1) HOLD(*NO)
             CALL       PGM(AL#RB4) PARM(&P1IAFB &P1IAFP)

 END:
             ENDPGM
