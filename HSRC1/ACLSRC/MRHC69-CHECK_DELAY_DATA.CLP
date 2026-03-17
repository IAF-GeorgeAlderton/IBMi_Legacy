             /*** MRHC69 ***********************************/
             /* CHECK DELAY DATA                           */
             /*  QY.LIU            2024.06.24              */
             /**********************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
      /*     DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)  */
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)

             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&SFILE)   TYPE(*CHAR) LEN(10)

             DCL        VAR(&MRHWP65) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MRHWP72) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&SLIB)  VALUE('HSRC1')
             CHGVAR     VAR(&SFILE) VALUE('ADDSSRC')
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&MRHWP65) VALUE('MRHWP65' *CAT &WS3)
             CHGVAR     VAR(&MRHWP72) VALUE('MRHWP72' *CAT &WS3)

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             DLTF       FILE(&WLIB/&MRHWP65)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(&WLIB/&MRHWP72)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(&WLIB/&MRHWP65) +
                          SRCFILE(&SLIB/&SFILE) SRCMBR(MRHWP65) +
                          OPTION(*NOLIST *NOSRC) SIZE(99999 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(MRHWP65) TOFILE(&WLIB/&MRHWP65)
             CRTPF      FILE(&WLIB/&MRHWP72) +
                          SRCFILE(&SLIB/&SFILE) SRCMBR(MRHWP72) +
                          OPTION(*NOLIST *NOSRC) SIZE(99999 500 3) +
                          LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(MRHWP72) TOFILE(&WLIB/&MRHWP72)
 #STP10:
             CALL       PGM(MRHR69)
 #STP20:
             DLTOVR     FILE(MRHWP65)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(MRHWP72)
             MONMSG     MSGID(CPF0000)

 END:
             ENDPGM
