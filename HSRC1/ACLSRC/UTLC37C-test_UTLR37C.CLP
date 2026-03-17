             PGM
             /** UTLC37C (1 DAY) *******************************/
             /**************************************************/

             DCL        VAR(&DT8  ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SIGN ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DAY1 ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MAX  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LT   ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TGT8 ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&DT8  ) VALUE('20250421')
             CHGVAR     VAR(&SIGN ) VALUE('+')
             CHGVAR     VAR(&DAY1 ) VALUE('MON')
             CHGVAR     VAR(&MAX  ) VALUE('6')

             CALL  PGM(UTLR37C) PARM(&DT8 &SIGN &DAY1 &MAX &TGT8 &RTN)

             ENDPGM
