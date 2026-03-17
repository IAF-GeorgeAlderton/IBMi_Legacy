PGM
             DCL        VAR(&HIN1  ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&HIN2  ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&HIN3  ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&THAI  ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&HTHZ  ) TYPE(*DEC ) LEN(8 0)
             DCL        VAR(&WIHZ  ) TYPE(*DEC ) LEN(8 0)
             DCL        VAR(&WITM  ) TYPE(*DEC ) LEN(6 0)

             CHGVAR     VAR(&HIN1) VALUE('90119')
             CHGVAR     VAR(&HIN2) VALUE('A0130')
             CHGVAR     VAR(&HIN3) VALUE('  ')
             CHGVAR     VAR(&THAI) VALUE('774')
             CHGVAR     VAR(&HTHZ) VALUE(20181106)
             CHGVAR     VAR(&WIHZ) VALUE(0)
             CHGVAR     VAR(&WITM) VALUE(0)

             CALL       PGM(AJSR1Z) PARM(&HIN1 &HIN2 &HIN3 &THAI +
                          &HTHZ &WIHZ &WITM)
ENDPGM
