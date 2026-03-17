             PGM        PARM(&PDATA &PCR1 &PCB1 &PCR2 &PCB2 &FILT &PCMD)
             /** AGJC40 **********************************************/
             /* INQ #OF A-PICS KANBAN (GROUPING)                     */
             /*    SAKAKI.         2019.10.11                        */
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
             DCL        VAR(&PCR1) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PCB1) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PCR2) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PCB2) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDATA) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&AGJWP40) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AGJWP41) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AGJWP42) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AGJWP43) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&AGJWP40) VALUE('AGJWP40' *CAT &WS3)
             CHGVAR     VAR(&AGJWP41) VALUE('AGJWP41' *CAT &WS3)
             CHGVAR     VAR(&AGJWP42) VALUE('AGJWP42' *CAT &WS3)
             CHGVAR     VAR(&AGJWP43) VALUE('AGJWP43' *CAT &WS3)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO
 STP10:
 STP11:
 STPA1:
             DLTF       FILE(&WLIB/&AGJWP40)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AGJWP40) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AGJWP40) OPTION(*NOLIST *NOSRC) +
                          SIZE(500000 1500 3) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&WLIB/&AGJWP41)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AGJWP41) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AGJWP41) OPTION(*NOLIST *NOSRC) +
                          SIZE(5000 1500 3) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&WLIB/&AGJWP42)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AGJWP42) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AGJWP42) OPTION(*NOLIST *NOSRC) +
                          SIZE(5000 1500 3) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&WLIB/&AGJWP43)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AGJWP43) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AGJWP43) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 1500 3) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AGJWP40) TOFILE(&WLIB/&AGJWP40)
             OVRDBF     FILE(AGJWP41) TOFILE(&WLIB/&AGJWP41)
             OVRDBF     FILE(AGJWP42) TOFILE(&WLIB/&AGJWP42)
             OVRDBF     FILE(AGJWP43) TOFILE(&WLIB/&AGJWP43)
             CALL       PGM(AGJR41) PARM(&PDATA &PCR1 &PCB1 &PCR2 +
                          &PCB2 &FILT &PCMD)
             OVRDBF     FILE(AGJWP40) TOFILE(&WLIB/&AGJWP40)
             OVRDBF     FILE(AGJWP41) TOFILE(&WLIB/&AGJWP41)
             OVRDBF     FILE(AGJWP42) TOFILE(&WLIB/&AGJWP42)
             CALL       PGM(AGJR42) PARM(&PDATA &PCR1 &PCB1 &PCR2 +
                          &PCB2 &PCMD)

 #END:       ENDPGM
