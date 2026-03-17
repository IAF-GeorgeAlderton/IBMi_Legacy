             PGM        PARM(&SHN)

             DCL        VAR(&SHN  ) TYPE(*CHAR) LEN(12)
             DCL        VAR(&DATE ) TYPE(*CHAR) LEN( 8)
             DCL        VAR(&MAXH ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             CALL       PGM(UTLR67) PARM(&SHN &DATE &MAXH &RTN)

             ENDPGM
