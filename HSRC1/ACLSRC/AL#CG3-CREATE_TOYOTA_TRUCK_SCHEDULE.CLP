             PGM
             /** AL#CG3 ************************/
             /* CREATE TOYOTA TRUCK SCHEDULE   */
             /*   T.SAKAKI         2016.08.12  */
             /**********************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&AL#WPC0) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AL#WPG3) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AL#WPG4) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AL#WPG5) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AL#WPGA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AL#WPGB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MSGTXT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)

             DCL        VAR(&P1SDAT) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&P1EDAT) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&P1KIHZ) TYPE(*DEC) LEN(8 0)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
           /*--------------------------------------------*/
           /*    CHECK ENVIRONMENT                        */
           /*--------------------------------------------*/
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             CHGVAR     VAR(&AL#WPC0) VALUE('AL#WPC0' *CAT &WS3)
             CHGVAR     VAR(&AL#WPG3) VALUE('AL#WPG3' *CAT &WS3)
             CHGVAR     VAR(&AL#WPG4) VALUE('AL#WPG4' *CAT &WS3)
             CHGVAR     VAR(&AL#WPG5) VALUE('AL#WPG5' *CAT &WS3)
             CHGVAR     VAR(&AL#WPGA) VALUE('AL#WPGA' *CAT &WS3)
             CHGVAR     VAR(&AL#WPGB) VALUE('AL#WPGB' *CAT &WS3)
             CHGJOB     OUTQ(&PRTG)
 #STP10:
      /* GET REGISTERED DATA */
             DLTF       FILE(&WLIB/&AL#WPC0)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AL#WPC0) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AL#WPC0) +
                          OPTION(*NOLIST *NOSRC) SIZE(500 500 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AL#WPC0) TOFILE(&WLIB/&AL#WPC0)
             CALL       PGM(AL#RC0)
 #STP20:
    /* INPUT SCREEN */
             CALL       PGM(AL#RG3) PARM(&P1SDAT &P1EDAT &P1KIHZ &PCMD)
             IF         COND(&PCMD *EQ '01') THEN(DO)
             GOTO       CMDLBL(END)
             ENDDO
 #STP30:
             DLTF       FILE(&WLIB/&AL#WPG3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AL#WPG3) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AL#WPG3) OPTION(*NOLIST *NOSRC) +
                          SIZE(500000 5000 3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AL#WPG3) TOFILE(&WLIB/&AL#WPG3)

    /* COLLECT FORECAST */
             CALL       PGM(AL#RG4) PARM(&P1SDAT &P1EDAT &P1KIHZ &PCMD)

             RTVMBRD    FILE(&WLIB/&AL#WPG3) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             GOTO       CMDLBL(#STP10)
             ENDDO
 #STP35:
             DLTF       FILE(&WLIB/&AL#WPGA)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AL#WPGA) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AL#WPGA) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AL#WPGA) TOFILE(&WLIB/&AL#WPGA)
    /* SUMMARY BY SUB ROUTE */
             CALL       PGM(AL#RGA)

 #STP40:
             DLTF       FILE(&WLIB/&AL#WPG4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AL#WPG4) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AL#WPG4) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AL#WPG4) TOFILE(&WLIB/&AL#WPG4)

             DLTF       FILE(&WLIB/&AL#WPGB)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AL#WPGB) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AL#WPGB) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AL#WPGB) TOFILE(&WLIB/&AL#WPGB)
    /* SUMMARY BY DATE AND SUB ROUTE */
             CALL       PGM(AL#RG5)

 #STP50:
             DLTF       FILE(&WLIB/&AL#WPG5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AL#WPG5) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AL#WPG5) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AL#WPG5) TOFILE(&WLIB/&AL#WPG5)
    /* CALCULATE TRUCK SCHEDULE */
             CALL       PGM(AL#RG6)

    /* INQUIRY TRUCK SCHEDULE */
 #STP60:     CALL       PGM(AL#RG7) PARM(&P1SDAT &P1EDAT)

             IF         COND(&USER *EQ 'TEST') THEN(DO)
             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD('"C:/PROGRAM FILES/IBM/CLIENT +
                          ACCESS/RTOPCB.EXE" +
                          C:/AS400/TTO/TOYOTANAIJIT.DTF') PAUSE(*NO)
             GOTO       CMDLBL(END)
                        ENDDO

 #STP70:     STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)
             STRPCCMD   PCCMD('"C:/PROGRAM FILES/IBM/CLIENT +
                          ACCESS/RTOPCB.EXE" +
                          C:/AS400/TTO/TOYOTANAIJIH.DTF') PAUSE(*NO)

 END:
             ENDPGM
