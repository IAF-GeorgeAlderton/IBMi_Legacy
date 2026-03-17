             PGM
             /** MBDC30 ************************************/
             DCL        VAR(&END) TYPE(*CHAR) LEN(1)
             DCL        VAR(&EDT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SDT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&YM) TYPE(*CHAR) LEN(6)

             CLRPFM MBDWP30

             CALL       PGM(MBDR30) PARM(&END)

             IF         COND(&END *EQ ' ') THEN(GOTO CMDLBL(@END))

             STRPCO
             MONMSG     MSGID(IWS0000)

             STRPCCMD   PCCMD('C:¥PROGRA‾1¥MICROS‾1¥OFFICE¥EXCEL.EXE +
                          S:¥LIST¥MBDWP30.XLS')
  @END:

             ENDPGM
