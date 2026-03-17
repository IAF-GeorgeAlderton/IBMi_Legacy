             PGM
             /*** AK#C01 ***********************************/
             /* PRIORITY LIST                              */
             /*  ITS.              2015.05.15              */
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
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&AK#WP01) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AK#WP02) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGTXT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&POUTQ) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             CHGVAR     VAR(&AK#WP01) VALUE('AK#WP01' *CAT &WS3)
             CHGVAR     VAR(&AK#WP02) VALUE('AK#WP02' *CAT &WS3)

             CHGJOB     OUTQ(&PRTG)

 #STP00:
             CALL       PGM(AK#R00) PARM(&POUTQ &PCMD)
             IF         COND(&PCMD *EQ '01') THEN(DO)
             GOTO       CMDLBL(END)
             ENDDO
 #STP10:
             DLTF       FILE(&WLIB/&AK#WP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AK#WP01) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AK#WP01) +
                          OPTION(*NOLIST *NOSRC) SIZE(9999 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             DLTF       FILE(QTEMP/AB#WPS3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(HWFILE1/AB#WPS3) +
                          TOFILE(QTEMP/AB#WPS3) CRTFILE(*YES)
             OVRDBF     FILE(AK#WP01) TOFILE(&WLIB/&AK#WP01)
             CALL       PGM(AK#R01)
             RTVMBRD    FILE(&WLIB/&AK#WP01) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&MSGTXT) VALUE('THERE ARE NO LIST DATA (G)')
             CHGVAR     VAR(&PKINP) VALUE('G    ')
             CHGVAR     VAR(&PKOUT) VALUE(' ')
             CALL       PGM(APLR90) PARM(&MSGTXT &PKINP &WSID &PKOUT)
             GOTO       CMDLBL(END)
             ENDDO
 #STP20:
             DLTF       FILE(&WLIB/&AK#WP02)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AK#WP02) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AK#WP02) +
                          OPTION(*NOLIST *NOSRC) SIZE(9999 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AK#WP01) TOFILE(&WLIB/&AK#WP01)
             OVRDBF     FILE(AK#WP02) TOFILE(&WLIB/&AK#WP02)
             CALL       PGM(AK#R02)
 #STP30:
             OVRPRTF    FILE(AK#PR03) PAGESIZE(*N 198) LPI(6) +
                          CPI(15) OVRFLW(62) RPLUNPRT(*YES) +
                          OUTQ(&POUTQ) FORMTYPE(K6H1) HOLD(*NO)
             OVRDBF     FILE(AK#WP02) TOFILE(&WLIB/&AK#WP02)
             CALL       PGM(AK#R03)

 END:
             ENDPGM
