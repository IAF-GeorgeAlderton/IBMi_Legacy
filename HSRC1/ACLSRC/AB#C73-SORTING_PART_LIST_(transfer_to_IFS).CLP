             PGM
/*= AB#C73 ===============================================*/
/*  PROGRAM    : SORTING PART LIST (TRANSFER TO IFS)      */
/*  WRITTEN    : 05/13/2016                               */
/*  WRITTEN BY : JW(SRAA)                                 */
/*========================================================*/

             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10) VALUE('HWFILE1')
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DIR) TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIR2) TYPE(*CHAR) LEN(100)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(18) +
                          VALUE('SORTING PART LIST ')
             DCL        VAR(&HDR) TYPE(*CHAR) LEN(30) VALUE('SORTING +
                          PART LIST (HEADER)')
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATE6) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DATE8) TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&DIR) +
                          VALUE('QNTC/IAF-AS400-FILE/AS400-TRANS/PC/D+
                          ownload/' *CAT &USER)

      /* CREATE WORK */
             CRTDUPOBJ  OBJ(AB#WP73) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP73

             CRTDUPOBJ  OBJ(AB#WP73H) FROMLIB(*LIBL) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP73H

             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&DATE6)
             CHGVAR     VAR(%SUBSTRING(&DATE8 3 6)) VALUE(&DATE6)
             CHGVAR     VAR(%SUBSTRING(&DATE8 1 2)) VALUE('20')
             CHGVAR     VAR(&DIR2) VALUE(&DIR *TCAT '/' *TCAT &FILE +
                          *CAT &DATE8 *TCAT '.csv')
      /* CREATE DIRECTRY */
             CRTDIR     DIR(&DIR )
             MONMSG     MSGID(CPFA0A0)
             MONMSG     MSGID(CPFA0A9)

      /* COPT 0 RECORD */
             CPYTOIMPF  FROMFILE(QTEMP/AB#WP73H) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +
                          TIMFMT(*USA)
             MONMSG     MSGID(CPF2817)

      /* CREATE AB#WP73 (FCEPP01:PART M/F) */

             CALL       AB#R73
             CPYF       FROMFILE(QTEMP/AB#WP73) +
                          TOFILE(QTEMP/AB#WP73H) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802) EXEC(GOTO CMDLBL(ENDPGM))
             MONMSG     MSGID(CPF2817) EXEC(GOTO CMDLBL(ENDPGM))

      /* TRANSFER.....*/
             CPYTOIMPF  FROMFILE(QTEMP/AB#WP73H) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +
                          TIMFMT(*USA) ADDCOLNAM(*SYS)

             MONMSG     MSGID(CPC2957 CPF2817) EXEC(DO)
             SNDPGMMSG  MSG('There is no target record or cannot use +
                          outpu IFS. Please run again or ask to IT +
                          Group.') TOMSGQ(&WSID) MSGTYPE(*INFO)
             GOTO         ENDPGM
             ENDDO

             SNDPGMMSG  MSG('Report has been created in your user +
                          directory (J:) +
                          PC\Download\user-id\SORTING PART LIST +
                          yyyymmdd.csv') TOMSGQ(&WSID) MSGTYPE(*INFO)

ENDPGM:      ENDPGM
