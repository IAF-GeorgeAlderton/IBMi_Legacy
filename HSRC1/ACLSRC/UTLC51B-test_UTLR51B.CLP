             PGM

             DCL        VAR(&CRHZ ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&FILE ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOHZ ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ODRN ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PICK#) TYPE(*CHAR) LEN(9)

             CHGVAR     VAR(&CRHZ ) VALUE('20241008')
             CHGVAR     VAR(&FILE ) VALUE('AB#WP2O')
             CHGVAR     VAR(&USER ) VALUE('I0239')
             CHGVAR     VAR(&NONY ) VALUE('3550')
             CHGVAR     VAR(&NOHZ ) VALUE('20241011')
             CHGVAR     VAR(&ODRN ) VALUE('111415-01 ')

             CALL       PGM(UTLR51B) PARM(&CRHZ &FILE &USER &NONY +
                          &NOHZ &ODRN &PICK#)

             ENDPGM
