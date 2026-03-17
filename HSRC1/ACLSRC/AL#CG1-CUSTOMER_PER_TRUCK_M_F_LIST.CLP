  PGM
/** AL#CG1 ************************************************/
/*  CUSTOMER PER TRUCK M/F LIST                           */
/*    M.OKUMURA           2016.08.25                      */
/**********************************************************/

             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DIR) TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIR2) TYPE(*CHAR) LEN(100)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(27) +
                          VALUE('CUSTOMER PER TRUCK MF LIST')

             CHGVAR     VAR(&LIB) VALUE('HFILE1')

             RTVJOBA    JOB(&WS) USER(&USER)
             CHGVAR     VAR(&DIR) +
                          VALUE('QNTC/IAF-AS400-FILE/AS400-TRANS/PC/+
                          Download/' *CAT &USER)
             CHGVAR     VAR(&DIR2) VALUE(&DIR *TCAT '/' *TCAT &FILE +
                          *TCAT '.csv')

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

      /* CREATE DIRECTRY */
             CRTDIR     DIR(&DIR )
             MONMSG     MSGID(CPFA0A0)
             MONMSG     MSGID(CPFA0A9)

      /* TRANSFER.....*/
             CPYTOIMPF  FROMFILE(&LIB/AL#PLG4) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +
                          TIMFMT(*USA) ADDCOLNAM(*SYS)
             MONMSG     MSGID(CPF2817)

             SNDPGMMSG  MSG('Report has been created in your user +
                          directory (R:) +
                          PC\Download\user-id\CUSTOMER PER TRUCK +
                          M/F LIST.csv') TOMSGQ(&WS) MSGTYPE(*INFO)
 #END:
             DLTOVR     FILE(*ALL)
             ENDPGM
