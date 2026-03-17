             PGM        PARM(&FIL1 &WLIB &FNAM)
     /*= APLC90 ===============================================*/
     /*  DATA TRANSFER CSV DATA TO IFS FOR DB                  */
     /*       T.SAKAKI    2016.11.04                           */
     /*========================================================*/
/*JW1*/      DCL        VAR(&DIR)   TYPE(*CHAR) LEN(100)
/*JW1*/      DCL        VAR(&DIR2)  TYPE(*CHAR) LEN(100)
/*JW1*/      DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
/*JW1*/      DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)

/*JW1*/      DCL        VAR(&FILE)  TYPE(*CHAR) LEN(50)
/*JW1*/      DCL        VAR(&FIL1)  TYPE(*CHAR) LEN(10)
/*JW1*/      DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
/*JW1*/      DCL        VAR(&WLIB2) TYPE(*CHAR) LEN(10)
/*JW1*/      DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(23)
/*JW1*/      DCL        VAR(&PMSG)  TYPE(*CHAR) LEN(256)

/*JW1*/      DCL        VAR(&DATE6) TYPE(*CHAR) LEN(6)
/*JW1*/      DCL        VAR(&DATE8) TYPE(*CHAR) LEN(8)

             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WLIB2) VALUE(&WLIB)
 /*JW============================================================*/
 /* DATA TRANSFER  TO QNTC/IAF-AS400-FILE/AS400-TRANS/PC/DOWNLOAD*/
 /*==============================================================*/
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&DATE6)
             CHGVAR     VAR(%SUBSTRING(&DATE8 3 6)) VALUE(&DATE6)
             CHGVAR     VAR(%SUBSTRING(&DATE8 1 2)) VALUE('20')
             CHGVAR     VAR(&FILE) VALUE(&FNAM *TCAT '-' *TCAT +
                          &DATE8 *CAT '.csv')


             CHGVAR     VAR(&DIR) +
                          VALUE('QNTC/IAF-AS400-FILE/AS400-TRANS/P+
                          C/Download/' *CAT &USER)
      /* CREATE DIRECTRY */
             CRTDIR     DIR(&DIR )
             MONMSG     MSGID(CPFA0A0)
             MONMSG     MSGID(CPFA0A9)

      /* CREATE DUPOBJ */
             CRTDUPOBJ  OBJ(&FIL1) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

      /* COPY 0 RECORD */
             CHGVAR     VAR(&DIR2) VALUE(&DIR *TCAT '/' *TCAT &FILE)
             CPYTOIMPF  FROMFILE(QTEMP/&FIL1) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +
                          TIMFMT(*USA)
             MONMSG     MSGID(CPF2817)

      /* TRANSFER.....*/
             CPYTOIMPF  FROMFILE(&WLIB/&FIL1) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +
                          TIMFMT(*USA) ADDCOLNAM(*NONE)
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(&PMSG) VALUE('REPORT HAS BEEN CREATED IN +
                          YOUR USER DIRECTORY (J:) +
                          PC\DOWNLOAD\USER-ID\' *CAT &FILE)

      /* SEND MESSAGE.*/
             CALL       PGM(APLR92) PARM(&PMSG &PKINP &WSID &PKOUT)

END:
             DLTOVR     FILE(*ALL)
             ENDPGM
