             PGM

             DCL        VAR(&PLNT ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SHCD ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOKU ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&PLNT ) VALUE('HCL')
             CHGVAR     VAR(&SHCD ) VALUE('51907502')

             CALL       PGM(UTLR74) PARM(&PLNT &SHCD &TOKU &NONY &RTN)

             ENDPGM
