             PGM
             /*** AL#CF0 ***********************************/
             /* LIST OF COMPLETE PALLETS                   */
             /*  ITS.              2015.05.26              */
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
             DCL        VAR(&AL#WPF0) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AL#WPF3) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AL#WPF4) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P1DATE) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&P1OUTP) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             CHGVAR     VAR(&AL#WPF0) VALUE('AL#WPF0' *CAT &WS3)
             CHGVAR     VAR(&AL#WPF3) VALUE('AL#WPF3' *CAT &WS3)
             CHGVAR     VAR(&AL#WPF4) VALUE('AL#WPF4' *CAT &WS3)

             CHGJOB     OUTQ(&PRTG)

 #STP00:
             CALL       PGM(AL#RF0) PARM(&P1DATE &PCMD &P1OUTP)
             IF         COND(&PCMD *EQ '01') THEN(DO)
             GOTO       CMDLBL(END)
             ENDDO
 #STP10:
             DLTF       FILE(&WLIB/&AL#WPF0)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AL#WPF0) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AL#WPF0) +
                          OPTION(*NOLIST *NOSRC) SIZE(500 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AL#WPF0) TOFILE(&WLIB/&AL#WPF0)
             CALL       PGM(AL#RF1) PARM(&P1DATE &PCMD)
 #STP20:
             OVRDBF     FILE(AL#WPF0) TOFILE(&WLIB/&AL#WPF0)
             CALL       PGM(AL#RF2) PARM(&PCMD)
             IF         COND(&PCMD *EQ '03') THEN(DO)
             GOTO       CMDLBL(#STP00)
             ENDDO
 #STP30:
             DLTF       FILE(&WLIB/&AL#WPF3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AL#WPF3) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AL#WPF3) OPTION(*NOLIST *NOSRC) +
                          SIZE(5000 5000 10) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AL#WPF0) TOFILE(&WLIB/&AL#WPF0)
             OVRDBF     FILE(AL#WPF3) TOFILE(&WLIB/&AL#WPF3)
             CALL       PGM(AL#RF3) PARM(&P1DATE &PCMD)
             RTVMBRD    FILE(&WLIB/&AL#WPF3) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(END))
 #STP40:
             DLTF       FILE(&WLIB/&AL#WPF4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AL#WPF4) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AL#WPF4) OPTION(*NOLIST *NOSRC) +
                          SIZE(5000 5000 10) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AL#WPF3) TOFILE(&WLIB/&AL#WPF3)
             OVRDBF     FILE(AL#WPF4) TOFILE(&WLIB/&AL#WPF4)
             CALL       PGM(AL#RF4)
 #STP50:
             IF         COND(&P1OUTP *EQ '1') THEN(DO)
             OVRPRTF    FILE(AL#PRF5) LPI(6) OVRFLW(60) +
                          RPLUNPRT(*YES) OUTQ(LANPRT06) +
                          FORMTYPE(K6H1) HOLD(*NO)
                                                ENDDO

             IF         COND(&P1OUTP *EQ '2') THEN(DO)
             OVRPRTF    FILE(AL#PRF5) LPI(6) OVRFLW(60) +
                          RPLUNPRT(*YES) OUTQ(LANPRT31) +
                          FORMTYPE(K6H1) HOLD(*NO)
                                                ENDDO

      /**********         RPLUNPRT(*YES) OUTQ(LANPRT13) +      ********/
             IF         COND(&P1OUTP *EQ '3') THEN(DO)
             OVRPRTF    FILE(AL#PRF5) LPI(6) OVRFLW(60) +
                          RPLUNPRT(*YES) OUTQ(LANPRT08) +
                          FORMTYPE(K6H1) HOLD(*NO)
                                                ENDDO

             CALL       PGM(AL#RF5) PARM(&P1DATE &PCMD)
 END:
             ENDPGM
