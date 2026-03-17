             PGM
             /*** MRHC21 ***********************************/
             /*部品マスタメンテナンス                    */
             /*  TR-ITS            2014.02.03              */
             /**********************************************/

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             DCL        VAR(&MRHWP21) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MRHWP23) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MRHWP31) TYPE(*CHAR) LEN(10)
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

             CHGVAR     VAR(&MRHWP21) VALUE('MRHWP21' *CAT &WS3)
             CHGVAR     VAR(&MRHWP23) VALUE('MRHWP23' *CAT &WS3)
             CHGVAR     VAR(&MRHWP31) VALUE('MRHWP31' *CAT &WS3)

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             DLTF       FILE(&WLIB/&MRHWP21)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&MRHWP21) +
                          SRCFILE(&SLIB/&SFILE) SRCMBR(MRHWP21) +
                          OPTION(*NOLIST *NOSRC) SIZE(500 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(MRHWP21) TOFILE(&WLIB/&MRHWP21)

             DLTF       FILE(&WLIB/&MRHWP23)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&MRHWP23) +
                          SRCFILE(&SLIB/&SFILE) SRCMBR(MRHWP23) +
                          OPTION(*NOLIST *NOSRC) SIZE(500 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(MRHWP23) TOFILE(&WLIB/&MRHWP23)

             DLTF       FILE(&WLIB/&MRHWP31)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&MRHWP31) +
                          SRCFILE(&SLIB/&SFILE) SRCMBR(MRHWP31) +
                          OPTION(*NOLIST *NOSRC) SIZE(500 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(MRHWP31) TOFILE(&WLIB/&MRHWP31)
 #STP10:
             CALL       PGM(MRHR21)
 #STP20:
             DLTOVR     FILE(MRHWP21)
             DLTOVR     FILE(MRHWP23)
             DLTOVR     FILE(MRHWP31)

 END:
             ENDPGM
