             PGM

             DCL        VAR(&CUS ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&YMD ) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&TIM ) TYPE(*DEC) LEN(6 0)

             CHGVAR     VAR(&CUS) VALUE('MTMUS')
             CHGVAR     VAR(&YMD) VALUE(20211112)
             CHGVAR     VAR(&TIM) VALUE(103252)

             OVRPRTF    FILE(QPRINT) OUTQ(WATAOUTQ) FORMTYPE(K6H1)
             CALL       PGM(AB#R6H) PARM(&CUS  &YMD &TIM)

             ENDPGM
