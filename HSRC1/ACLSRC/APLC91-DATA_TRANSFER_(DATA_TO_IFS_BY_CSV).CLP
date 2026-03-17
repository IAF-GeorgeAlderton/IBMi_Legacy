             PGM        PARM(&DEPT &FILE &LIBL &FNAM)
     /*= APLC91 ===============================================*/
     /*  DATA TRANSFER CSV DATA TO IFS FOR CSV FORMAT WF       */
     /*       T.SAKAKI    2016.11.04                           */
     /*========================================================*/
             DCL        VAR(&DEPT)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(8)
             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(23)

             DCL        VAR(&DEPN)  TYPE(*CHAR) LEN(15)
             DCL        VAR(&DIR)   TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIR2)  TYPE(*CHAR) LEN(100)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)

             DCL        VAR(&WFIL)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&PMSG)  TYPE(*CHAR) LEN(256)

             DCL        VAR(&DATE6) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DATE8) TYPE(*CHAR) LEN(8)

             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER)

 /*JW======================================================*/
 /*   TO QNTC/IAF-AS400-FILE/AS400-TRANS/XX/DOWNLOAD       */
 /*========================================================*/

      /* ADD TIME STAMP */
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&DATE6)
             CHGVAR     VAR(&WFIL) VALUE(&FNAM *TCAT '-' *TCAT +
                          &DATE6 *CAT '.csv')

      /* GET DEPARTMENT NAME */
             IF         COND(&DEPT *EQ '1') THEN(DO)
             CHGVAR     VAR(&DEPN) VALUE('ACCOUNTING     ')
             ENDDO
             IF         COND(&DEPT *EQ '2') THEN(DO)
             CHGVAR     VAR(&DEPN) VALUE('MANUFACTURING  ')
             ENDDO
             IF         COND(&DEPT *EQ '3') THEN(DO)
             CHGVAR     VAR(&DEPN) VALUE('PC             ')
             ENDDO
             IF         COND(&DEPT *EQ '4') THEN(DO)
             CHGVAR     VAR(&DEPN) VALUE('SALES          ')
             ENDDO

      /* CREATE DIRECTRY */
             CHGVAR     VAR(&DIR) +
                          VALUE('QNTC/IAF-AS400-FILE/AS400-TRANS/' +
                          *TCAT &DEPN *TCAT '/Download/' *CAT &USER)

      /* CREATE DIRECTRY */
             CRTDIR     DIR(&DIR )
             MONMSG     MSGID(CPFA0A0)
             MONMSG     MSGID(CPFA0A9)
             CHGVAR     VAR(&DIR2) VALUE(&DIR *TCAT '/' *TCAT &WFIL)

      /* TRANSFER.....*/
             CPYTOIMPF  FROMFILE(&LIBL/&FILE) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          RMVBLANK(*BOTH) DATFMT(*USA) TIMFMT(*USA) +
                          ADDCOLNAM(*NONE)
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(&PMSG) VALUE('REPORT HAS BEEN CREATED IN +
                          YOUR USER DIRECTORY (J:) +
                          DEPARTMENT\DOWNLOAD\USER-ID\' *CAT &WFIL)

      /* SEND MESSAGE.*/
             CALL       PGM(APLR92) PARM(&PMSG &PKINP &WSID &PKOUT)

END:
             DLTOVR     FILE(*ALL)
             ENDPGM
