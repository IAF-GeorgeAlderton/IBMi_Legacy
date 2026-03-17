             PGM

             DCL        VAR(&CRHZ ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&FILE ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLNT ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SEQ# ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PICK#) TYPE(*CHAR) LEN(9)

             CHGVAR     VAR(&CRHZ ) VALUE('20241008')
             CHGVAR     VAR(&FILE ) VALUE('ABF7P01')
             CHGVAR     VAR(&USER ) VALUE('I0111')
             CHGVAR     VAR(&PLNT ) VALUE('5426')
             CHGVAR     VAR(&SEQ# ) VALUE('20241210')

             CALL       PGM(UTLR51C) PARM(&CRHZ &FILE &USER &PLNT +
                          &SEQ# &PICK#)

             ENDPGM
