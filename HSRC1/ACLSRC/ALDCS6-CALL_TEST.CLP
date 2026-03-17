             PGM

             DCL        VAR(&KBN  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ZETI ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&TEHI ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PLPD ) TYPE(*DEC ) LEN(8 0)
             DCL        VAR(&PLPT ) TYPE(*DEC ) LEN(4 0)
             DCL        VAR(&PLPS ) TYPE(*DEC ) LEN(4 0)

             CHGVAR     VAR(&KBN  ) VALUE('A')
             CHGVAR     VAR(&ZETI ) VALUE('4422')
             CHGVAR     VAR(&TEHI ) VALUE('045')
             CHGVAR     VAR(&PLPD ) VALUE(0)
             CHGVAR     VAR(&PLPT ) VALUE(0)
             CHGVAR     VAR(&PLPS ) VALUE(0)

             CALL       PGM(ALDRS6) PARM(&KBN &ZETI &TEHI &PLPD &PLPT &PLPS)

             ENDPGM
