             PGM

             DCL        VAR(&DATE ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DAY1 ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&DAY2 ) TYPE(*CHAR) LEN(4)

             CHGVAR     VAR(&DATE ) VALUE('20241201')
             CHGVAR     VAR(&DAY1 ) VALUE('0031')

             CALL       PGM(UTLR02B) PARM(&DATE &DAY1 &DAY2)

             ENDPGM
