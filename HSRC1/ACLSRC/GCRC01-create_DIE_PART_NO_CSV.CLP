PGM
             DCL        VAR(&DIR) TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIR2) TYPE(*CHAR) LEN(100)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER2) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(15) +
                          VALUE('DIE-PART NO.CSV')

           /*--------------------------------------------*/
           /*    CHECK ENVIRONMENT                        */
           /*--------------------------------------------*/
            RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             CHGVAR     VAR(&USER2) VALUE(%SST(&USER 1 2))

             CHGVAR     VAR(&DIR) +
                          VALUE('QNTC/IAF-AS400-FILE/AS400-TRANS/Manu+
                          facturing/Download/' *CAT &USER)

      /* FOR ACCOUNTING */
             IF         COND(&USER2 *EQ 'I4') THEN(DO)
             CHGVAR     VAR(&DIR) VALUE(' ')
             CHGVAR     VAR(&DIR) +
                          VALUE('QNTC/IAF-AS400-FILE/AS400-TRANS/Acco+
                          unting/Download/' *CAT &USER)
             ENDDO

      /* CREATE DIRECTRY */
             CRTDIR     DIR(&DIR )
             MONMSG     MSGID(CPFA0A0)
             MONMSG     MSGID(CPFA0A9)


GOTO JUMP1

CLRPFM GCRWP01

CALL GCRR00

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

ENDPGM
