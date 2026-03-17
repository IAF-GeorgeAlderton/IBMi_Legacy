             PGM        PARM(&HHMM)
             /*** AGIC11 ***********************************/
             /* A-PICS SORT                                */
             /*  ITS.              2013.11.25              */
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
             DCL        VAR(&AGIWP08) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AGIWP30) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AGIWP31) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&HHMM) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             CHGVAR     VAR(&AGIWP08) VALUE('AGIWP08')
             CHGVAR     VAR(&AGIWP30) VALUE('AGIWP30')
             CHGVAR     VAR(&AGIWP31) VALUE('AGIWP31')

             CHGJOB     OUTQ(&PRTG)

 #STP10:
             DLTF       FILE(&WLIB/&AGIWP08)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AGIWP08) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AGIWP08) +
                          OPTION(*NOLIST *NOSRC) SIZE(5000 500 +
                          3) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&WLIB/&AGIWP30)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AGIWP30) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AGIWP30) +
                          OPTION(*NOLIST *NOSRC) SIZE(5000 500 +
                          3) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&WLIB/&AGIWP31)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AGIWP31) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AGIWP31) +
                          OPTION(*NOLIST *NOSRC) SIZE(5000 500 +
                          3) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AGIWP08) TOFILE(&WLIB/&AGIWP08)
             OVRDBF     FILE(AGIWP30) TOFILE(&WLIB/&AGIWP30)
             OVRDBF     FILE(AGIWP31) TOFILE(&WLIB/&AGIWP31)
             CALL       PGM(AGIR08)
             CALL       PGM(AGIR11)
             CALL       PGM(AGIR12) PARM(&HHMM)
             CALL       PGM(AGIR13) PARM(&HHMM)

 END:
             ENDPGM
