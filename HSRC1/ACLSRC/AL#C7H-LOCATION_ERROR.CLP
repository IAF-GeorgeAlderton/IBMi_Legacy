             PGM
             /*** AL#C7H ***********************************/
             /* LOCATION ERROR                             */
             /*  ITS.              2015.06.10              */
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
             DCL        VAR(&AL#WP77) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AL#WP7H) TYPE(*CHAR) LEN(11)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&#@OUTQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P1IAFB) TYPE(*CHAR) LEN(03)
             DCL        VAR(&P1IAFP) TYPE(*CHAR) LEN(03)

    /*SEND MAIL SET */
             DCL        VAR(&TO1)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&SUB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FNAME)  TYPE(*CHAR) LEN(30)
             CHGVAR     VAR(&TO1) +
                          VALUE('ATSUO.MAMIYA@IAFI.COM')
             CHGVAR     VAR(&SUB) VALUE('LOCA ERR')
             CHGVAR     VAR(&FNAME) VALUE('LOCATION ERR DATA.TXT')

             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             CHGVAR     VAR(&AL#WP77) VALUE('AL#WP77' *CAT &WS3)
             CHGVAR     VAR(&AL#WP7H) VALUE('AL#WP7H' *CAT &WS3)
             CHGJOB     OUTQ(&PRTG)
 #STP10:
 #STP20:
 #STP30:
             OVRDBF     FILE(AL#WP77) TOFILE(&WLIB/&AL#WP77)
             OVRPRTF    FILE(AL#PR7H) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) HOLD(*YES)
             CALL       PGM(AL#R7H)
 #STP40:
             DLTF       FILE(&AL#WP7H)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&AL#WP7H) RCDLEN(128) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             CALL       PGM(APLC31) PARM('AL#PR7H   ' 'HWFILE1   ' +
                          &AL#WP7H)
             CALL       PGM(APLC30) PARM(&TO1 &SUB 'HWFILE1' +
                          &AL#WP7H &FNAME)
 END:
             ENDPGM
