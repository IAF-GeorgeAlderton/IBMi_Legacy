             PGM
             /********************************************/
             /* DSM UNLOAD                               */
             /* JW(SRAA) 12/22/2015                      */
             /********************************** AB#C0C **/

             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10) VALUE('HWFILE1')
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DIR) TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIR2) TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIR3) TYPE(*CHAR) LEN(100)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(21) VALUE('DSM +
                          UNLOAD REPORT')
             DCL        VAR(&HDR) TYPE(*CHAR) LEN(30) VALUE('DSM +
                          UNLOAD REPORT (HEADER)')
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)

            RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&DIR) +
                          VALUE('QNTC/IAF-AS400-FILE/AS400-TRANS/ACCO+
                          UNTING/Download/' *CAT &USER)

             CHGVAR     VAR(&DIR2) VALUE(&DIR *TCAT '/' *TCAT &FILE +
                          *TCAT '.csv')
             CHGVAR     VAR(&DIR3) VALUE(&DIR *TCAT '/' *TCAT &HDR  +
                          *TCAT '.csv')
      /* CREATE DIRECTRY */
             CRTDIR     DIR(&DIR )
             MONMSG     MSGID(CPFA0A0)
             MONMSG     MSGID(CPFA0A9)

      /* COPY 0 RECORD */
      /* CREATE WORK */
             CLRPFM     FILE(&WLIB/AJSPQ01)
             CPYTOIMPF  FROMFILE(&WLIB/AJSPQ01) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +
                          TIMFMT(*USA)
             MONMSG     MSGID(CPF2817)

             RUNQRY     QRY(HOBJ1/AJSQ06) RCDSLT(*YES)

      /* TRANSFER.....*/
             CPYTOIMPF  FROMFILE(QTEMP/AJSPQ06) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +
                          TIMFMT(*USA) ADDCOLNAM(*SYS)

             MONMSG     MSGID(CPC2957 CPF2817) EXEC(DO)
             SNDPGMMSG  MSG('There is no target record. Please run +
                          again or ask to IT Group.') TOMSGQ(&WSID) +
                          MSGTYPE(*INFO)
             GOTO         ENDPGM
             ENDDO

             SNDPGMMSG  MSG('Report has been created in your user +
                          directory (K:) +
                          ACCOUNTING\Download\user-id\DSM UNLOAD +
                          REPORT.csv') TOMSGQ(&WSID) MSGTYPE(*INFO)


ENDPGM:      ENDPGM
