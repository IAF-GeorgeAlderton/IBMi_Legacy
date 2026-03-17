             /** UTLC16  *****************************************/
             PGM

             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&OPT  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NAME ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&TOKU ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&NONY) VALUE('3503')
             CHGVAR     VAR(&OPT ) VALUE('D')

             CALL       PGM(UTLR16 ) PARM(&NONY &OPT  &NAME &TOKU &RTN)

             ENDPGM
