             PGM        PARM(&XFIL)
             /**** APLC02 *****************************************/
             /* TRANSFER PF TO CSV                                */
             /* JW  2019.10.24                                    */
             /*****************************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&XTYPE) TYPE(*CHAR) LEN(01)
             DCL        VAR(&XFIL ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&XLIB ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&XFILN) TYPE(*CHAR) LEN(30)
             DCL        VAR(&XCSV ) TYPE(*CHAR) LEN(01)

 /* END     */
             IF         COND(&XFIL *EQ ' ') THEN(GOTO CMDLBL(@EXIT))

 /* DEFAULT */
             CHGVAR     VAR(&XTYPE) VALUE('2')
             CHGVAR     VAR(&XCSV)  VALUE('Y')
             CHGVAR     VAR(&XFILN) VALUE(&XFIL)

             CHGVAR     VAR(&XLIB) VALUE('HFILE1')
             CHKOBJ     OBJ(&XLIB/&XFIL) OBJTYPE(*FILE) MBR(*FIRST)

             MONMSG     MSGID(CPF9801) EXEC(DO)
             CHGVAR     VAR(&XLIB) VALUE('HWFILE1')
             CHKOBJ     OBJ(&XLIB/&XFIL) OBJTYPE(*FILE) MBR(*FIRST)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@EXIT))
             ENDDO

             CALL       PGM(APLC94) PARM(&XTYPE &XFIL &XLIB &XFILN +
                          &XCSV 'N' 'Y')

 @EXIT:
             ENDPGM
