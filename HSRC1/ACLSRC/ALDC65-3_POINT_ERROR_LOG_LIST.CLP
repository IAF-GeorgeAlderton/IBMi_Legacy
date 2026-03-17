  PGM
/** ALDC65 ************************************************/
/*  3-POINT ERROR LOG LIST                                */
/*                                                        */
/* LEC   ADD CSV OUTPUT OPTION.                           */
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
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(27) VALUE('ERROR +
                          LOG LIST FOR 3PT SCAN')

             CHGVAR     VAR(&WLIB) VALUE('HWFILE1')

             RTVJOBA    JOB(&WS) USER(&USER)
             CHGVAR     VAR(&DIR) +
                          VALUE('QNTC/IAF-AS400-FILE/AS400-TRANS/PC/+
                          Download/' *CAT &USER)
             CHGVAR     VAR(&DIR2) VALUE(&DIR *TCAT '/' *TCAT &FILE +
                          *TCAT '.csv')

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             CLRPFM     FILE(&WLIB/ALDWP65X)
             MONMSG     MSGID(CPF2103 CPF3261 CPF2105)

             CLRPFM     FILE(&WLIB/ALDWP65Z)
             MONMSG     MSGID(CPF2103 CPF3261 CPF2105)

      /* CREATE DIRECTRY */
             CRTDIR     DIR(&DIR )
             MONMSG     MSGID(CPFA0A0)
             MONMSG     MSGID(CPFA0A9)

      /* COPY 0 RECORD */
             CPYTOIMPF  FROMFILE(&WLIB/ALDWP65X) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +
                          TIMFMT(*USA)
             MONMSG     MSGID(CPF2817)

/*                                                                */
/*                                                                */
/*                                                                */
             OVRDBF     FILE(ALDWP65X) TOFILE(&WLIB/ALDWP65X)

             CALL       PGM(ALDR65)
             MONMSG     MSGID(CPF2103 CPF3261 CPF2105)
/*                                                                */
/*                                                                */

             RTVMBRD    FILE(&WLIB/ALDWP65X) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(#END))

      /* CREATE ALDWP65Z  */
             CPYF       FROMFILE(&WLIB/ALDWP65X) +
                          TOFILE(&WLIB/ALDWP65Z) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2817) EXEC(GOTO CMDLBL(#END))

      /* TRANSFER.....*/
             CPYTOIMPF  FROMFILE(&WLIB/ALDWP65Z) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +
                          TIMFMT(*USA) ADDCOLNAM(*SYS)

             SNDPGMMSG  MSG('Report has been created in your user +
                          directory (J:) +
                          PC\Download\user-id\ERROR LOG LIST +
                          FOR 3PT SCAN.csv') TOMSGQ(&WS) MSGTYPE(*INFO)
 #END:
             DLTOVR     FILE(*ALL)
             ENDPGM
