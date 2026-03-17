             PGM
             /** UTLC37 (2 DAYS) *******************************/
             /**************************************************/

             DCL        VAR(&DT8  ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SIGN ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DAY1 ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&DAY2 ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MAX  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LT   ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TGT8 ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&DT8  ) VALUE('20240215')
             CHGVAR     VAR(&SIGN ) VALUE('-')
             CHGVAR     VAR(&DAY1 ) VALUE('MON')
             CHGVAR     VAR(&DAY2 ) VALUE('WED')
             CHGVAR     VAR(&MAX  ) VALUE('N')
             CHGVAR     VAR(&LT   ) VALUE('00')

             CALL  PGM(UTLR37) PARM(&DT8 &SIGN &DAY1 &DAY2 &MAX &LT &TGT8 &RTN)

             ENDPGM
