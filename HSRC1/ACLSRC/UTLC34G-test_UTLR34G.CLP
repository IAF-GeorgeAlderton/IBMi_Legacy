             PGM
             /** UTLC34G ***************************************/
             /**************************************************/
             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NUKE ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&BIN  ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ROUT ) TYPE(*CHAR) LEN(4)

             CHGVAR     VAR(&NONY ) VALUE('5100')
             CHGVAR     VAR(&NUKE ) VALUE('00')

             CALL       PGM(UTLR34G) PARM(&NONY &NUKE &BIN &ROUT)

             ENDPGM
