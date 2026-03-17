             PGM

             DCL        VAR(&CONT ) TYPE(*CHAR) LEN(18)
             DCL        VAR(&MAST ) TYPE(*CHAR) LEN(18)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&CONT ) VALUE('542600000000095962')

             CALL       PGM(UEXR54 ) PARM(&CONT &MAST &RTN)

             ENDPGM
