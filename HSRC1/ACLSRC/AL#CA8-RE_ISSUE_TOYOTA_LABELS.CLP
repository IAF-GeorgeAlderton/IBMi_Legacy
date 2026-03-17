             PGM
             /*** AL#CA8 ***********************************/
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
             DCL        VAR(&AL#WPA9) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P1DATE) TYPE(*DEC) LEN(8 0)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             CHGVAR     VAR(&AL#WPA9) VALUE('AL#WPA9' *CAT &WS3)

             CHGJOB     OUTQ(&PRTG)

 #STP00:
             CALL       PGM(AL#RA0) PARM(&P1DATE &PCMD)
             IF         COND(&PCMD *EQ '01') THEN(DO)
             GOTO       CMDLBL(END)
             ENDDO
 #STP10:
             DLTF       FILE(&WLIB/&AL#WPA9)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AL#WPA9) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AL#WPA9) +
                          OPTION(*NOLIST *NOSRC) SIZE(9999 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AL#WPA9) TOFILE(&WLIB/&AL#WPA9)
             CALL       PGM(AL#RA9) PARM(&P1DATE &PCMD)
 #STP20:
             OVRDBF     FILE(AL#WPA9) TOFILE(&WLIB/&AL#WPA9)
             CALL       PGM(AL#RA8) PARM(&PCMD)
             IF         COND(&PCMD *EQ '01') THEN(DO)
             GOTO       CMDLBL(#STP00)
             ENDDO
 #STP30:
      /*発行制御ファイル作成*/
             OVRDBF     FILE(AL#WPA9) TOFILE(&WLIB/&AL#WPA9)
             CALL       PGM(AL#RA4)
 #STP40:
 #STP50:
 END:
             ENDPGM
