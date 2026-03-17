             PGM

             DCL        VAR(&YYYY) TYPE(*DEC)  LEN(4 0)
             DCL        VAR(&MM  ) TYPE(*DEC)  LEN(2 0)
             DCL        VAR(&DD  ) TYPE(*DEC)  LEN(2 0)
             DCL        VAR(&YMD ) TYPE(*CHAR) LEN(8)

             CHGVAR     VAR(&YYYY) VALUE(2026)
             CHGVAR     VAR(&MM  ) VALUE(02)
             CHGVAR     VAR(&DD  ) VALUE(04)

             CALL       PGM(UTLR02M) PARM(&YYYY &MM &DD &YMD)

             ENDPGM
