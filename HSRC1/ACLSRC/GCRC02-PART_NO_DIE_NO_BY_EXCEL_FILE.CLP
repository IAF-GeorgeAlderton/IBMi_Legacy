PGM
/** GCRC02  ***********************************************/
/*   PART NO. -> DIE NO. BY EXCEL FILE                    */
/*                 T.SAKASHITA 15/11/09                   */
/************************************************ GCRC02 **/
             DCL        VAR(&DIR) TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIR2) TYPE(*CHAR) LEN(100)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(15) +
                          VALUE('DIE-PART NO.CSV')

             DCLF       FILE(GCRPW02)
           /*--------------------------------------------*/
           /*    CHECK ENVIRONMENT                        */
           /*--------------------------------------------*/
            RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             SNDRCVF    RCDFMT(GCRPW021)
             IF         (&IN01 *EQ '1') GOTO @END
             IF         (&IN05 *EQ '1') THEN(DO)

           /*--------------------------------------------*/
           /*    CRTDIR                                   */
           /*--------------------------------------------*/
             CHGVAR     VAR(&DIR) +
                          VALUE('QNTC/IAF-AS400-FILE/AS400-TRANS/Manu+
                          facturing/Download/' *CAT &USER)
      /* CREATE DIRECTRY */
             CRTDIR     DIR(&DIR )
             MONMSG     MSGID(CPFA0A0)
             MONMSG     MSGID(CPFA0A9)
           /*--------------------------------------------*/

             CPYFRMIMPF +
                          FROMSTMF('/QNTC/IAF-AS400-FILE/AS400-TRANS/+
                          MANUFACTURING/UPLOAD/GCRWP00.CSV') +
                          TOFILE(HWFILE1/GCRWP00) MBROPT(*REPLACE) +
                          FROMCCSID(*FILE) RCDDLM(*CRLF) +
                          STRDLM(*DBLQUOTE) DATFMT(*USA) +
                          TIMFMT(*USA) ERRRCDOPT(*REPLACE)

             MONMSG       MSGID(CPF2817) EXEC(DO)
             SNDPGMMSG  MSG('CHECK EXCEL DATA OR FILE NAME AND +
                          RE-TRY.') TOMSGQ(&WSID) MSGTYPE(*INFO)
             GOTO CMDLBL(@END)
             ENDDO

/* GOTO JUMP1 */

CLRPFM GCRWP01

/* GCRWP00 -> GCRWP01 */
CALL GCRRSK

JUMP1:
CALL GCRR01

JUMP2:
CLRPFM GCRWP02

CALL GCRR02

CLRPFM GCRWP03
CALL GCRR03

      /* CREATE WORK */
             CRTDUPOBJ  OBJ(GCRWP04) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/GCRWP04
      /* COPY 0 RECORD */
             CHGVAR     VAR(&DIR2) VALUE(&DIR *TCAT '/' *TCAT &FILE)
             CPYTOIMPF  FROMFILE(QTEMP/GCRWP04) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +
                          TIMFMT(*USA)
             MONMSG     MSGID(CPF2817)

CALL GCRR04


STRPCO     PCTA(*NO)
MONMSG     MSGID(CPF0000)

             STRPCCMD   PCCMD('C:/AS400/TTO/GCRWP03.TTO') PAUSE(*NO)

             STRPCCMD   PCCMD('C:/AS400/TTO/GCRWP03.DTF') PAUSE(*NO)

      /* TRANSFER.....*/
             CPYTOIMPF  FROMFILE(QTEMP/GCRWP04) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +
                          TIMFMT(*USA) ADDCOLNAM(*SYS)
MONMSG     MSGID(CPF0000)
       ENDDO

@END:  ENDPGM
