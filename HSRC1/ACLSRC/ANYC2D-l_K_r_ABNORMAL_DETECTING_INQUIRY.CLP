             /** ANYC2D **********************************************/
             /*つるべ生産指示 : ABNORMAL DETECTING INQUIRY         */
             /*                                                      */
             /*  2020.7.23                                           */
             /********************************************************/
             PGM
             DCL        VAR(&SYS)     TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3)     TYPE(*CHAR) LEN(3)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&REC)     TYPE(*DEC) LEN(10 0)
             DCL        VAR(&ANYWP24) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DIR)     TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIR2)    TYPE(*CHAR) LEN(100)
             DCL        VAR(&FIL1)    TYPE(*CHAR) LEN(23) +
                                    VALUE('WINDLASS KANBAN DETECT ')
             DCL        VAR(&FILE)    TYPE(*CHAR) LEN(50)
             DCL        VAR(&DATE6)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&DATE8)   TYPE(*CHAR) LEN(8)

             RTVNETA    SYSNAME(&SYS)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&ANYWP24) VALUE('ANYWP24' *CAT &WS3)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             RTVMBRD    FILE(QTEMP/ANYWP21) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)

             DLTF       FILE(&WLIB/&ANYWP24)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTDUPOBJ  OBJ(ANYWP24) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(&WLIB) NEWOBJ(&ANYWP24)
             CRTDUPOBJ  OBJ(&ANYWP24) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(ANYWP21) TOFILE(QTEMP/ANYWP21)
             OVRDBF     FILE(ANYWP24) TOFILE(&WLIB/&ANYWP24)
             CALL       PGM(ANYR24)

 /*==============================================================*/
 /* DATA TRANSFER  TO QNTC/IAF-AS400-FILE/AS400-TRANS/PC/DOWNLOAD*/
 /*==============================================================*/
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&DATE6)
             CHGVAR     VAR(%SUBSTRING(&DATE8 3 6)) VALUE(&DATE6)
             CHGVAR     VAR(%SUBSTRING(&DATE8 1 2)) VALUE('20')
             CHGVAR     VAR(&FILE) VALUE(&FIL1 *CAT &DATE8 *CAT '.csv')

             CHGVAR     VAR(&DIR) +
                          VALUE('QNTC/IAF-AS400-FILE/AS400-TRANS/P+
                          C/Download/' *CAT &USER)
      /* CREATE DIRECTRY */
             CRTDIR     DIR(&DIR )
             MONMSG     MSGID(CPFA0A0)
             MONMSG     MSGID(CPFA0A9)

      /* COPY 0 RECORD */
             CHGVAR     VAR(&DIR2) VALUE(&DIR *TCAT '/' *TCAT &FILE)
             CPYTOIMPF  FROMFILE(QTEMP/&ANYWP24) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +
                          TIMFMT(*USA)
             MONMSG     MSGID(CPF2817)

      /* TRANSFER.....*/
             DLTF       FILE(QTEMP/ANYWP24S)
             MONMSG     MSGID(CPF2817 CPF2105)
             CRTDUPOBJ  OBJ(ANYWP24S) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(&WLIB/&ANYWP24) +
                          TOFILE(QTEMP/ANYWP24S) MBROPT(*REPLACE) +
                          CRTFILE(*NO) FMTOPT(*NOCHK)

             CPYTOIMPF  FROMFILE(QTEMP/ANYWP24S) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +
                          TIMFMT(*USA) ADDCOLNAM(*SYS)
             MONMSG     MSGID(CPF0000)

             SNDPGMMSG  MSG('REPORT HAS BEEN CREATED IN YOUR USER +
                          DIRECTORY (J:) PC\DOWNLOAD\USER-ID\' *CAT  &FILE) +
                          TOMSGQ(&WSID) MSGTYPE(*INFO)

             ENDDO

             ENDPGM
