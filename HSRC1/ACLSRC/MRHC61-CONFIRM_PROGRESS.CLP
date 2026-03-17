             PGM
             /*** MRHC61 ***********************************/
             /*進捗確認                                  */
             /*  TR-ITS            2014.01.22              */
             /**********************************************/

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             DCL        VAR(&MRHWP51) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MRHWP65) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MRHWP71) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&SLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&SFILE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3)     TYPE(*CHAR) LEN(3)

             CHGVAR     VAR(&SLIB)  VALUE('HSRC1')
             CHGVAR     VAR(&SFILE) VALUE('ADDSSRC')
     /*      CHGVAR     VAR(&SLIB)  VALUE('AOYAMA')       */
     /*      CHGVAR     VAR(&SFILE) VALUE('ADDSSRC')      */

             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&MRHWP51) VALUE('MRHWP51' *CAT &WS3)
             CHGVAR     VAR(&MRHWP65) VALUE('MRHWP65' *CAT &WS3)
             CHGVAR     VAR(&MRHWP71) VALUE('MRHWP71' *CAT &WS3)

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             DLTF       FILE(&WLIB/&MRHWP51)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(&WLIB/&MRHWP65)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(&WLIB/&MRHWP71)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(&WLIB/&MRHWP51) SRCFILE(&SLIB/&SFILE) +
                          SRCMBR(MRHWP51) OPTION(*NOLIST *NOSRC) +
                          SIZE(99999 1000 3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(MRHWP51) TOFILE(&WLIB/&MRHWP51)
             CRTPF      FILE(&WLIB/&MRHWP65) SRCFILE(&SLIB/&SFILE) +
                          SRCMBR(MRHWP65) OPTION(*NOLIST *NOSRC) +
                          SIZE(99999 1000 3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(MRHWP65) TOFILE(&WLIB/&MRHWP65)
             CRTPF      FILE(&WLIB/&MRHWP71) SRCFILE(&SLIB/&SFILE) +
                          SRCMBR(MRHWP71) OPTION(*NOLIST *NOSRC) +
                          SIZE(99999 1000 3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(MRHWP71) TOFILE(&WLIB/&MRHWP71)

 #STP10:
             CALL       PGM(MRHR61)
 #STP20:
             DLTOVR     FILE(MRHWP51)
             DLTOVR     FILE(MRHWP65)
             DLTOVR     FILE(MRHWP71)

 END:
             ENDPGM
