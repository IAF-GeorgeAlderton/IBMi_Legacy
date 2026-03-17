/** GADC14 ************************************************/
/*  DELIVERY CODE AND ADDRESS LIST                        */
/*  J.WATANABE 3/15/2016                                  */
/**********************************************************/
             PGM

             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10) VALUE('HFILE1')
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DIR) TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIR2) TYPE(*CHAR) LEN(100)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(30) +
                          VALUE('Delivery Code and Address List')
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&DIR) +
                          VALUE('QNTC/IAF-AS400-FILE/AS400-TRANS/PC/D+
                          ownload/' *CAT &USER)

             CHGVAR     VAR(&DIR2) VALUE(&DIR *TCAT '/' *TCAT &FILE +
                          *TCAT '.csv')
      /* CREATE DIRECTRY */
             CRTDIR     DIR(&DIR )
             MONMSG     MSGID(CPFA0A0)
             MONMSG     MSGID(CPFA0A9)

      /* COPY 0 RECORD */
      /* CREATE WORK */
             CLRPFM     FILE(&WLIB/GADPQ14)
             DLTF       FILE(QTEMP/GADPQ14)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTDUPOBJ  OBJ(GADPQ14) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CPYTOIMPF  FROMFILE(QTEMP/GADPQ14) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +
                          TIMFMT(*USA)
             MONMSG     MSGID(CPF2817)

             RUNQRY     QRY(HOBJ1/GADQ14)

      /* TRANSFER.....*/
             CPYF       FROMFILE(QTEMP/GADPQ14) +
                          TOFILE(&WLIB/GADPQ14) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)

             CPYTOIMPF  FROMFILE(&WLIB/GADPQ14) TOSTMF(&DIR2) +
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
                          directory (J:) +
                          PC\Download\user-id\Delivery Code and +
                          Address List.csv') TOMSGQ(&WSID) +
                          MSGTYPE(*INFO)

ENDPGM:      ENDPGM
