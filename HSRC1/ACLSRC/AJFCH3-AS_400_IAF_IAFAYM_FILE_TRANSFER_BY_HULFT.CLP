             PGM        PARM(&PFILE &PLIBR &PER)
             /** AJFCH3 ****************************************/
             /*  ..AS/400 IAF <--> IAFAYM FILE TRANSFER..      */
             /*  .. HULFT VERSION                              */
             /*    T-SAKAKI                      2018.01.15    */
             /**************************************** AJFCH3 **/
             DCL        VAR(&PFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PER) TYPE(*CHAR) LEN(2)

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
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

             RTVJOBA    USER(&USER) JOB(&WSID)

             DLTF       FILE(APSAVLIB/&PFILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTSAVF    FILE(APSAVLIB/&PFILE) AUT(*ALL)

             SAVOBJ     OBJ(&PFILE) LIB(&PLIBR) DEV(*SAVF) +
                          OBJTYPE(*FILE) SAVF(APSAVLIB/&PFILE) +
                          TGTRLS(V7R3M0) SAVACT(*SYSDFN) DTACPR(*YES)

             MONMSG     MSGID(CPF3770) EXEC(DO)
             CHGVAR     VAR(&PER) VALUE('01')
             GOTO       END
             ENDDO

     /*---------------*/
     /*  .HULFT SND.  */
     /*---------------*/

     /* CREATE PARAMETERS FOR HULFT */
             CHGVAR     VAR(&FILEID) VALUE('F=' *TCAT 'FILETRN' *CAT +
                          &NULL)
             CHGVAR     VAR(&SFILE) VALUE('FILE=' *TCAT 'APSAVLIB' +
                          *TCAT '/' *TCAT &PFILE *CAT &NULL)
             CHGVAR     VAR(&SYST) VALUE('IAFAYM      ')
             CHGVAR     VAR(&HOST) VALUE('H=' *TCAT &SYST *CAT &NULL)

             CHGVAR     VAR(&ELIBL) VALUE('WEEKDLT')
             CHGVAR     VAR(&EFILE) VALUE('EJSEP10')
             CHGVAR     VAR(&ERFILE) VALUE('OUTPUT=' *TCAT &ELIBL +
                          *TCAT '/' *TCAT &EFILE *TCAT '(' *TCAT +
                          &EFILE *TCAT ')' *CAT &NULL)

     /* SRC MEMBER NAME */
             CHGVAR     VAR(&MSG0) VALUE('MSG0=' *TCAT '*FIRST' *CAT +
                          &NULL)

     /* SRC FILE NAME */
             CHGVAR     VAR(&MSG1) VALUE('MSG1=' *TCAT &PFILE *CAT +
                          &NULL)
     /* SRC LIBARARY */
             CHGVAR     VAR(&MSG2) VALUE('MSG2=' *TCAT &PLIBR *CAT +
                          &NULL)
     /* SAVE FILE NAME */
             CHGVAR     VAR(&PSLB) VALUE('IAFF' *TCAT &WSID)
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

             DLTF       FILE(APSAVLIB/&PFILE)
             MONMSG     MSGID(CPF3261 CPF2105)

 END:        ENDPGM
