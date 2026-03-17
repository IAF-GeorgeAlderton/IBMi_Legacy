             PGM
             /** AGJC50 **********************************************/
             /* CURRENT SETTING(BY #OF KANBAN)                       */
             /*    SAKAKI.          2020.01.07                       */
             /********************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
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
             DCL        VAR(&FILT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&AGJWP50) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AGJWP51) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&AGJWP50) VALUE('AGJWP50' *CAT &WS3)
             CHGVAR     VAR(&AGJWP51) VALUE('AGJWP51' *CAT &WS3)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO
 STP10:
 STP11:
 STPA1:
             DLTF       FILE(&WLIB/&AGJWP50)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AGJWP50) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AGJWP50) OPTION(*NOLIST *NOSRC) +
                          SIZE(500000 1500 3) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&WLIB/&AGJWP51)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AGJWP51) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AGJWP51) OPTION(*NOLIST *NOSRC) +
                          SIZE(500000 1500 3) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AGJWP50) TOFILE(&WLIB/&AGJWP50)
             OVRDBF     FILE(AGJWP51) TOFILE(&WLIB/&AGJWP51)
             CALL       PGM(AGJR51)
             OVRDBF     FILE(AGJWP50) TOFILE(&WLIB/&AGJWP50)
             OVRDBF     FILE(AGJWP51) TOFILE(&WLIB/&AGJWP51)
             CALL       PGM(AGJR52)

 #END:       ENDPGM
