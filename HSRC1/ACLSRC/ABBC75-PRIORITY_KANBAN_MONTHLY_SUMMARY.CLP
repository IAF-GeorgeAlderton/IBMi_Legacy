             PGM
             DCL        VAR(&EID) TYPE(*CHAR) LEN(1)

             CLRPFM ABBWP75
             CALL       PGM(ABBR75) PARM(&EID)
             IF         COND(&EID *NE ' ') THEN(GOTO CMDLBL(@END))

        /*   STRPCO    */
        /*   MONMSG     MSGID(IWS4010)    */
       /*    STRPCCMD   PCCMD('PCSFT5.EXE C:¥PKAN\PW75.TTO') */
        /*   STRPCCMD   +
                          PCCMD('C:¥PROGRA~1¥MICROS~1¥OFFICE¥EXCEL.EX+
                          E  C:¥PKAN¥PW75.XLS')   */
  @END:
             ENDPGM
