             PGM

             DCL        VAR(&MAX) TYPE(*DEC) LEN(3 0)

             CHGVAR     VAR(&MAX) VALUE(060)

             OVRDBF     FILE(ABWPP31) TOFILE(TWFILE1/ABWPP31)
             OVRDBF     FILE(AB#PP71) TOFILE(TFILE1/AB#PP71)

             CALL       PGM(AB#R482N) PARM(&MAX)

             ENDPGM
