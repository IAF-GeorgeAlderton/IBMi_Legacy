             PGM
             DCL        VAR(&CMD) TYPE(*CHAR) LEN(2)

             DLTF       FILE(QTEMP/ABBWP351)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/ABBWP352)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ABBWP351) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ABBWP352) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

 STP01:
             CLRPFM     QTEMP/ABBWP351
             CLRPFM     QTEMP/ABBWP352

             OVRDBF     FILE(ABBWP351) TOFILE(QTEMP/ABBWP351)
             OVRDBF     FILE(ABBWP352) TOFILE(QTEMP/ABBWP352)

             CALL       PGM(ABBR35) PARM(&CMD)

             DLTOVR     FILE(*ALL)
             IF         COND(&CMD *EQ '05') THEN(GOTO CMDLBL(STP01))

 END:
             ENDPGM
