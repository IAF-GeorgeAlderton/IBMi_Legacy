             PGM

             DCL        VAR(&IN   ) TYPE(*DEC ) LEN(15 6)
             DCL        VAR(&TRUE ) TYPE(*CHAR) LEN(17)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&IN  )  VALUE(-00000000034.000000000)

             CALL       PGM(UTLR64) PARM(&IN &TRUE &RTN)

             ENDPGM
