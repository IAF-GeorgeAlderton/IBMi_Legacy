             PGM
             /** MBDCP3 *******************************************/
             /* CREATE CSV FILE FOR PAST N MONTH NO RESULT LIST   */
             /* J WATANABE 2/10/2016                              */
             /* JW1        4/12/2017 ADD SALES DIRECTORY          */
             /*****************************************************/
             DCLF       FILE(MBDPW31)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PHYM1) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MCEDP01) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10) VALUE('HWFILE1')
             DCL        VAR(&DIR) TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIR2) TYPE(*CHAR) LEN(100)
             DCL        VAR(&REC ) TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(19) VALUE('PAST +
                          NO RESULT LIST')
             DCL        VAR(&XUSR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&STAMP) TYPE(*CHAR) LEN(21)
             DCL        VAR(&DATE)  TYPE(*CHAR) LEN(8)

             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)
             CHGJOB     SWS(00000000)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&PHYM1) VALUE(%SUBSTRING(&MCEDP01 1 6))
             CHGVAR     VAR(&XMONTH) VALUE(3)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(MBDPW311)
             CHGVAR     VAR(&XMSG)  VALUE(' ')

             IF         (&IN01 *EQ '1') GOTO ENDP


      /*     IF         COND(&XMONTH *EQ 0 ) THEN(DO)     */
      /*     CHGVAR     VAR(&IN85) VALUE('1')             */
      /*     CHGVAR     VAR(&XMSG) +                      */
      /*                  VALUE('ENTER MONTH!')           */
      /*     GOTO       STP1                              */
      /*     ENDDO                                        */

             IF         COND(&IN05 *EQ '0') THEN(DO)
             CHGVAR     VAR(&IN85) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('PRESS CMD1 TO EXIT OR CMD5 +
                          TO RUN.')
             GOTO       STP1
             ENDDO

      /* CREATE MBDWP31 */
             CLRPFM     FILE(&WLIB/MBDWP31)
             CALL       PGM(MBDR31) PARM(&PHYM1 &XMONTH)

      /* CREATE MBDWP32 */
             CLRPFM     FILE(&WLIB/MBDWP32)
             CALL       PGM(MBDR32) PARM(&XMONTH &XUSR)

      /* TRANSFER.....*/
             IF         COND(&XUSR *EQ 'I3') THEN(DO)
             CHGVAR     VAR(&DIR) +
                          VALUE('QNTC/IAF-AS400-FILE/AS400-TRANS/Sale+
                          s/Download/' *CAT &USER)
             ENDDO
             IF         COND(&XUSR *NE 'I3') THEN(DO)
             CHGVAR     VAR(&DIR) +
                          VALUE('QNTC/IAF-AS400-FILE/AS400-TRANS/PC/D+
                          ownload/' *CAT &USER)
             ENDDO

      /* CREATE DIRECTRY */
             CRTDIR     DIR(&DIR )
             MONMSG     MSGID(CPFA0A0)
             MONMSG     MSGID(CPFA0A9)

      /* COPY 0 RECORD */
             CLRPFM     FILE(&WLIB/MBDWP33)

      /* RETRIEVE TODAY'S DATE */
             CALL       PGM(UTLR08) PARM(&STAMP)
             CHGVAR     VAR(&DATE) VALUE(&STAMP)

             CHGVAR     VAR(&DIR2) VALUE(&DIR *TCAT '/' *TCAT &FILE +
                          *BCAT &DATE *TCAT '.csv')

             CPYTOIMPF  FROMFILE(&WLIB/MBDWP33) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +
                          TIMFMT(*USA)
             MONMSG     MSGID(CPF2817)

      /* CHECK RECORD NO. OF MBDWP32 */
             RTVMBRD    FILE(&WLIB/MBDWP32) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(ENDP))

      /* COPY MBDWP32 TO MBDWP33 */
             CPYF       FROMFILE(&WLIB/MBDWP32) +
                          TOFILE(&WLIB/MBDWP33) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)

      /* TRANSFER MBDWP33 TO IFS(PC/DOWNLOAD) */
             CPYTOIMPF  FROMFILE(&WLIB/MBDWP33) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +
                          TIMFMT(*USA) ADDCOLNAM(*SYS)
             MONMSG     MSGID(CPF0000)

 ENDP:       ENDPGM
