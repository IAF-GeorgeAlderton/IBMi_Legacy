             PGM        PARM(&N)

             DCL        VAR(&N) TYPE(*CHAR) LEN(10)

             DLTOBJ     OBJ(SAVEPGM/&N) OBJTYPE(*PGM)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(&N) FROMLIB(HOBJ1) OBJTYPE(*PGM) +
                          TOLIB(SAVEPGM) NEWOBJ(&N) DATA(*NO) +
                          FILEID(*YES)

             ENDPGM
