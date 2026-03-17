             PGM
/*= AB#C72 ===============================================*/
/*  PROGRAM    : TMS CASE LABEL REPORT                    */
/*  WRITTEN    : 2015/11/5                                */
/*  WRITTEN BY : JW(SRA)                                  */
/*========================================================*/

             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10) VALUE('HWFILE1')
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DIR) TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIR2) TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIR3) TYPE(*CHAR) LEN(100)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(21) VALUE('TMS +
                          CASE LABEL REPORT')
             DCL        VAR(&HDR) TYPE(*CHAR) LEN(30) VALUE('TMS +
                          CASE LABEL REPORT (HEADER)')
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)

            RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&DIR) +
                          VALUE('QNTC/IAF-AS400-FILE/AS400-TRANS/PC/+
                          Download/' *CAT &USER)

      /* CREATE WORK */
             CRTDUPOBJ  OBJ(AB#WP72) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP72

             CHGVAR     VAR(&DIR2) VALUE(&DIR *TCAT '/' *TCAT &FILE +
                          *TCAT '.csv')
             CHGVAR     VAR(&DIR3) VALUE(&DIR *TCAT '/' *TCAT &HDR  +
                          *TCAT '.csv')
      /* CREATE DIRECTRY */
             CRTDIR     DIR(&DIR )
             MONMSG     MSGID(CPFA0A0)
             MONMSG     MSGID(CPFA0A9)

      /* COPT 0 RECORD */
             CPYTOIMPF  FROMFILE(QTEMP/AB#WP72) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +
                          TIMFMT(*USA)
             MONMSG     MSGID(CPF2817)

      /* CREATE AB#WP72 (AB#PP66:TMS CASE INFO FOR ASN) */

             RUNQRY     QRY(HOBJ1/AB#Q72) RCDSLT(*YES)
             CPYF       FROMFILE(QTEMP/AB#WP72X) +
                          TOFILE(QTEMP/AB#WP72) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802) EXEC(GOTO CMDLBL(ENDPGM))
             MONMSG     MSGID(CPF2817) EXEC(GOTO CMDLBL(ENDPGM))

      /* TRANSFER.....*/
             CPYTOIMPF  FROMFILE(QTEMP/AB#WP72) TOSTMF(&DIR2) +
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
                          directory (J:) PC\Download\user-id\TMS +
                          CASE LABEL REPORT.csv') TOMSGQ(&WSID) +
                          MSGTYPE(*INFO)


ENDPGM:      ENDPGM
