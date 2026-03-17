             PGM        PARM(&SHIN)

             DCL        VAR(&SHIN ) TYPE(*CHAR) LEN(12)
             DCL        VAR(&INV  ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             CALL       PGM(UTLR80) PARM(&SHIN &INV &RTN)

             ENDPGM
