             PGM        PARM(&PPGM &PSRC &PLIB)
             /** AJFCH1 ****************************************/
             /*  ..AS/400 IAF <--> IAFAYM SOURCE TRANSFER..    */
             /*  .. HULFT VERSION                              */
             /*    T-SAKAKI                      2018.01.15    */
             /**************************************** AJFCH1 **/
             DCL        VAR(&PPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PSRC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB) TYPE(*CHAR) LEN(10)

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYST) TYPE(*CHAR) LEN(12)
             DCL        VAR(&PSLB) TYPE(*CHAR) LEN(10)

             DCL        VAR(&NULL) TYPE(*CHAR) LEN(1) VALUE(X'00')

             DCL        VAR(&FILEID) TYPE(*CHAR) LEN(13)
             DCL        VAR(&SFILE) TYPE(*CHAR) LEN(33)
             DCL        VAR(&HOST) TYPE(*CHAR) LEN(71)
             DCL        VAR(&ELIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&EFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERFILE) TYPE(*CHAR) LEN(41)
             DCL        VAR(&EXT) TYPE(*CHAR) LEN(8)

             DCL        VAR(&MSG0) TYPE(*CHAR) LEN(16)
             DCL        VAR(&MSG1) TYPE(*CHAR) LEN(16)
             DCL        VAR(&MSG2) TYPE(*CHAR) LEN(16)
             DCL        VAR(&MSG3) TYPE(*CHAR) LEN(16)

             RTVJOBA    USER(&USER)

             DLTF       FILE(IKOULIB/&PPGM)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTSRCPF   FILE(IKOULIB/&PPGM) IGCDTA(*YES) +
                          SIZE(*NOMAX) CCSID(5026) AUT(*ALL)

             CPYSRCF    FROMFILE(&PLIB/&PSRC) TOFILE(IKOULIB/&PPGM) +
                          FROMMBR(&PPGM) TOMBR(&PPGM)

             MONMSG     MSGID(CPF2817 CPF2105 CPF2868) EXEC(DO)
             DLTF       FILE(IKOULIB/&PPGM)
             MONMSG     MSGID(CPF3261 CPF2105)
             GOTO       END
             ENDDO

             DLTF       FILE(APSAVLIB/&PPGM)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTSAVF    FILE(APSAVLIB/&PPGM) AUT(*ALL)

             SAVOBJ     OBJ(&PPGM) LIB(IKOULIB) DEV(*SAVF) +
                          OBJTYPE(*FILE) SAVF(APSAVLIB/&PPGM) +
                          TGTRLS(V7R3M0) DTACPR(*YES)

     /*---------------*/
     /*  .HULFT SND.  */
     /*---------------*/

     /* CREATE PARAMETERS FOR HULFT */
             CHGVAR     VAR(&FILEID) VALUE('F=' *TCAT 'SRCTRN' *CAT +
                          &NULL)
             CHGVAR     VAR(&SFILE) VALUE('FILE=' *TCAT 'APSAVLIB' +
                          *TCAT '/' *TCAT &PPGM *CAT &NULL)
             CHGVAR     VAR(&SYST) VALUE('IAFAYM      ')
             CHGVAR     VAR(&HOST) VALUE('H=' *TCAT &SYST *CAT &NULL)

             CHGVAR     VAR(&ELIBL) VALUE('WEEKDLT')
             CHGVAR     VAR(&EFILE) VALUE('EJSEP10')
             CHGVAR     VAR(&ERFILE) VALUE('OUTPUT=' *TCAT &ELIBL +
                          *TCAT '/' *TCAT &EFILE *TCAT '(' *TCAT +
                          &EFILE *TCAT ')' *CAT &NULL)

     /* SRC MEMBER NAME */
             CHGVAR     VAR(&MSG0) VALUE('MSG0=' *TCAT &PPGM *CAT +
                          &NULL)
     /* SRC FILE NAME */
             CHGVAR     VAR(&MSG1) VALUE('MSG1=' *TCAT &PSRC *CAT +
                          &NULL)
     /* SRC LIBARARY */
             CHGVAR     VAR(&MSG2) VALUE('MSG2=' *TCAT &PLIB *CAT +
                          &NULL)
     /* SAVE FILE NAME */
             CHGVAR     VAR(&PSLB) VALUE('IAFHSRC   ')
       /*    CHGVAR     VAR(&PSLB) VALUE('IAFFILE   ')   */
             CHGVAR     VAR(&MSG3) VALUE('MSG3=' *TCAT &PSLB *CAT +
                          &NULL)

             CHGVAR     VAR(&EXT) VALUE('       ' *CAT &NULL)
                                       /*1234567*/

      /*----------------*/
      /* SEND COMMAND   */
      /*----------------*/
             CALL       PGM(HULFT/UTLSEND) PARM(&FILEID &SFILE &HOST +
                          'SYNC' &MSG0 &MSG1 &MSG2 &MSG3 &ERFILE +
                          'EXIT' &EXT)

     /*****/

             DLTF       FILE(IKOULIB/&PPGM)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(APSAVLIB/&PPGM)
             MONMSG     MSGID(CPF3261 CPF2105)


 END:        ENDPGM
