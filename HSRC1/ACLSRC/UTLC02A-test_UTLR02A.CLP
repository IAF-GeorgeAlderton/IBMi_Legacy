             PGM

             DCL        VAR(&DATE1) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DAY  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATE2) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&DATE1) VALUE('20210826')
             CHGVAR     VAR(&DAY  ) VALUE('1')

             CALL       PGM(UTLR02A) PARM(&DATE1 &DAY &DATE2 &RTN)

             ENDPGM
