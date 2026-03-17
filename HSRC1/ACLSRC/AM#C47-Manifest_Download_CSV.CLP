  PGM
/** AM#C47  ***********************************************/
/*  MANIFEST WORKFILE  - TO CSV                           */
/*                                                        */
/* LEC   2019/07/03                                       */
/**********************************************************/

             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DIR) TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIR2) TYPE(*CHAR) LEN(100)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(27) VALUE('MANIFEST +
                          DOWNLOAD')

             CHGVAR     VAR(&WLIB) VALUE('HWFILE1')

             RTVJOBA    JOB(&WS) USER(&USER)
             CHGVAR     VAR(&DIR) +
                          VALUE('/QNTC/IAF-AS400-FILE/AS400-TRANS/PC/+
                          Download/' *CAT &USER)
             CHGVAR     VAR(&DIR2) VALUE(&DIR *TCAT '/' *TCAT &FILE +
                          *TCAT '.csv')

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             CLRPFM     FILE(&WLIB/AM#WP46X)
             MONMSG     MSGID(CPF2103 CPF3261 CPF2105)

      /* CREATE DIRECTRY */
             CRTDIR     DIR(&DIR )
             MONMSG     MSGID(CPFA0A0)
             MONMSG     MSGID(CPFA0A9)

      /* COPY 0 RECORD */
             CPYTOIMPF  FROMFILE(&WLIB/AM#WP46X) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +
                          TIMFMT(*USA)
             MONMSG     MSGID(CPF2817)

/*                                                                */
             OVRDBF     FILE(AM#WP46X) TOFILE(&WLIB/AM#WP46X)

             CALL       PGM(AM#R46X)
             MONMSG     MSGID(CPF2103 CPF3261 CPF2105)
/*                                                                */
/*                                                                */

             RTVMBRD    FILE(&WLIB/AM#WP46X) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(#END))

      /* TRANSFER.....*/
             CPYTOIMPF  FROMFILE(&WLIB/AM#WP46X) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +
                          TIMFMT(*USA) ADDCOLNAM(*SYS)

             SNDPGMMSG  MSG('CSV has been created in your user +
                          directory (J:) +
                          PC\Download\user-id\MANIFEST DOWNLOAD+
                          .csv') TOMSGQ(&WS) MSGTYPE(*INFO)
 #END:
             DLTOVR     FILE(*ALL)
             ENDPGM
