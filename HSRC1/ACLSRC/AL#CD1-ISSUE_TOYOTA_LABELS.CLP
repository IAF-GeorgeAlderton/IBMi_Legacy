             PGM        PARM(&OUTR)
             /*** AL#CD1 ***********************************/
             /* RE-ISSUE TOYOTA LABELS                     */
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
             DCL        VAR(&AL#WPD1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&OUTR)     TYPE(*DEC)  LEN(5 0)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             CHGVAR     VAR(&AL#WPD1) VALUE('AL#WPD1' *CAT &WS3)

             CHGJOB     OUTQ(&PRTG)

             CHGVAR     VAR(&OUTR)  VALUE(0)
 #STP10:
 #STP20:
 #STP30:
      /*転送データ　　　*/
             DLTF       FILE(&WLIB/&AL#WPD1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AL#WPD1) RCDLEN(0256) +
                          OPTION(*NOLIST *NOSRC) SIZE(9999 5000 3) +
                          LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AL#WPD1) TOFILE(&WLIB/&AL#WPD1)
             CALL       PGM(AL#RD1)
             RTVMBRD    FILE(&WLIB/&AL#WPD1) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(END))
 #STP40:
 #STP50:
 #STP55:
 #STP60:
      /*転送データコピー*/
             DLTF       FILE(HWFILE1/EDIDATA)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/EDIDATA) RCDLEN(0256) +
                          OPTION(*NOLIST *NOSRC) SIZE(9999 5000 3) +
                          LVLCHK(*NO) AUT(*ALL)
             CPYF       FROMFILE(&WLIB/&AL#WPD1) +
                          TOFILE(HWFILE1/EDIDATA) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             CHGVAR     VAR(&OUTR) VALUE(1)
 #STP70:
 END:
             ENDPGM
