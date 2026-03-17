             PGM        PARM(&LIBL &FILE &SLIBL &SFILE &RCV &HFID &SFNM1)
             /** EJKC64 ***********************************/
             /*  B2B_S EDI DATA SENDING PROCESS           */
             /*    **ORIGINAL IS JN020C FROM ASJ**        */
             /*    T.SAKAKI                   2016.10.13  */
             /********************************** EJSC01 **/
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SLIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SFIL2) TYPE(*CHAR) LEN(17)
             DCL        VAR(&ELIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&EFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&HFID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RCV) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LEN) TYPE(*DEC) LEN(5 0)

             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)

             DCL        VAR(&JFILE) TYPE(*CHAR) LEN(12)
             DCL        VAR(&SDFILE) TYPE(*CHAR) LEN(32)
             DCL        VAR(&RCVHT) TYPE(*CHAR) LEN(12)
             DCL        VAR(&ERFILE) TYPE(*CHAR) LEN(32)
             DCL        VAR(&SFNM1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SFNM2) TYPE(*CHAR) LEN(20)
             DCL        VAR(&EFIL2) TYPE(*CHAR) LEN(17)

             RTVJOBA    USER(&USER)

     /* RECEPTION FILE  /EJSWP01(EJSWP01)      */
             CHGVAR     VAR(&SFIL2) VALUE('/' *TCAT &SFILE *TCAT '(' +
                          *TCAT &SFILE *TCAT ')')

     /* ERROR FILE   /EJSEP01(EJSEP01)      */
             CHGVAR     VAR(&EFILE) VALUE('EJSEP01')
             CHGVAR     VAR(&ELIBL) VALUE('WEEKDLT')
             IF         COND(&USER *EQ 'TEST') THEN(DO)
             CHGVAR     VAR(&ELIBL) VALUE('TWFILE1')
             ENDDO
             CHGVAR     VAR(&EFIL2) VALUE('/' *TCAT &EFILE *TCAT '(' +
                          *TCAT &EFILE *TCAT ')')

     /* GET RECORD FORMAT LENGTH */
             DLTF       FILE(QTEMP/EJKWP64)
             MONMSG     MSGID(CPF3261 CPF2105)
             DSPFD      FILE(&LIBL/&FILE) TYPE(*RCDFMT) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/EJKWP64)
             CALL       PGM(EJKR64) PARM(&LEN)

     /* CREATE RECEPTION FILE */
             DLTF       FILE(&SLIBL/&SFILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&SLIBL/&SFILE) RCDLEN(&LEN)

     /* COPY FROM SAVED FILE */
             CPYF       FROMFILE(&LIBL/&FILE) +
                          TOFILE(&SLIBL/&SFILE) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)

     /* CREATE PARAMETERS FOR HULFT */
             CHGVAR     VAR(&JFILE) VALUE('F=' *TCAT &HFID)
             CHGVAR     VAR(&SDFILE) VALUE('FILE=' *TCAT &SLIBL +
                          *TCAT &SFIL2)
             CHGVAR     VAR(&RCVHT) VALUE('H=' *TCAT &RCV)
             CHGVAR     VAR(&ERFILE) VALUE('OUTPUT=' *TCAT &ELIBL +
                          *TCAT &EFIL2)
                /* FILE NAME 'S830FCO.TXT' */
             CHGVAR     VAR(&SFNM2) VALUE('MSGL0=' *TCAT &SFNM1 *TCAT '.TXT')

     /*------------------------- */
     /* SENDING PROCESS AT HULFT */
     /*------------------------- */
             CALL       PGM(EJKC65) PARM(&JFILE &SDFILE &RCVHT &ERFILE +
                          &SFNM2 'S' &HFID &FILE)
@END:
             ENDPGM
