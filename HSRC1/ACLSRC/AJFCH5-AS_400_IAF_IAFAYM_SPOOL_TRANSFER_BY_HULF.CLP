             PGM        PARM(&PSPOL &PER)
             /** AJFCH5 ****************************************/
             /*  ..AS/400 IAF <--> IAFAYM SPOOL TRANSFER..     */
             /*  .. HULFT VERSION                              */
             /*    T-SAKAKI                      2018.02.13    */
             /************************************* AJFCH5 *****/
             DCL        VAR(&PSPOL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PER) TYPE(*CHAR) LEN(2)

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&POBJ)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYST) TYPE(*CHAR) LEN(12)
             DCL        VAR(&PSLB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NULL) TYPE(*CHAR) LEN(1) VALUE(X'00')
             DCL        VAR(&PLIBR) TYPE(*CHAR) LEN(10)
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

     /*--------------------------*/
     /*    CHECK ENVIRONMENT     */
     /*--------------------------*/
             RTVJOBA    USER(&USER)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             CHGVAR     VAR(&POBJ) VALUE('HOBJ1     ')
             CHGVAR     VAR(&SYST) VALUE('AOYAMA      ')
     /* FOR TEST USER  */
             IF         COND(&USER *EQ 'TEST      ') THEN(DO)
             CHGVAR     VAR(&POBJ) VALUE('TOBJ1     ')
             CHGVAR     VAR(&SYST) VALUE('IAFAYM      ')
             ENDDO
     /*--------------------------*/
     /*    CHANGE SPOOL          */
     /*--------------------------*/
             CHGSPLFA   FILE(&PSPOL) SPLNBR(*LAST) +
                          OUTQ(&POBJ/IAFSPLTRN)

             DLTF       FILE(&WLIB/IAFSPLTRN)
             MONMSG     MSGID(CPF2105 CPF0000)
             CRTSAVF    FILE(&WLIB/IAFSPLTRN)

             SAVOBJ     OBJ(IAFSPLTRN) LIB(&POBJ) DEV(*SAVF) +
                          SAVF(&WLIB/IAFSPLTRN) TGTRLS(V7R3M0) +
                          SPLFDTA(*ALL)

     /*---------------*/
     /*  .HULFT SND.  */
     /*---------------*/

     /* CREATE PARAMETERS FOR HULFT */
             CHGVAR     VAR(&FILEID) VALUE('F=' *TCAT 'SPLTRN' *CAT +
                          &NULL)
             CHGVAR     VAR(&SFILE) VALUE('FILE=' *TCAT &WLIB +
                          *TCAT '/' *TCAT 'IAFSPLTRN' *CAT &NULL)
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
             CHGVAR     VAR(&MSG1) VALUE('MSG1=' *TCAT 'IAFSPLTRN' +
                          *CAT &NULL)
     /* SRC LIBARARY */
             CHGVAR     VAR(&MSG2) VALUE('MSG2=' *TCAT &POBJ *CAT +
                          &NULL)
     /* RESTORE LIBRARY */
             CHGVAR     VAR(&PSLB) VALUE('IAFSPLTRN ')
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
      /*----------------*/
      /* FOR BACKUP     */
      /*----------------*/
             CHGSPLFA   FILE(&PSPOL) SPLNBR(*LAST) +
                          OUTQ(APSAVLIB/WEEKDLTQ)

             DLTF       FILE(APSAVLIB/IAFSPLTRN)
             MONMSG     MSGID(CPF2105 CPF0000)
             CRTSAVF    FILE(APSAVLIB/IAFSPLTRN)

             SAVOBJ     OBJ(WEEKDLTQ) LIB(APSAVLIB) DEV(*SAVF) +
                          SAVF(APSAVLIB/IAFSPLTRN) TGTRLS(V7R3M0) +
                          SPLFDTA(*ALL)

             DLTSPLF    FILE(&PSPOL) SPLNBR(*LAST)
             MONMSG     MSGID(CPF3309 CPF0000)

      /* COPY TO APSAVLIB/WEEKDLTQ */
             RSTOBJ     OBJ(WEEKDLTQ) SAVLIB(APSAVLIB) DEV(*SAVF) +
                          OBJTYPE(*OUTQ) SAVF(APSAVLIB/IAFSPLTRN) +
                          SPLFDTA(*NEW) RSTLIB(APSAVLIB)
      /*----------------*/
      /* CLROUTQ        */
      /*----------------*/
             CLROUTQ    OUTQ(&POBJ/IAFSPLTRN)

             ENDPGM
