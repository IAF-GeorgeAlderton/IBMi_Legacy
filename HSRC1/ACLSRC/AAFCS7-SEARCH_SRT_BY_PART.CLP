             PGM
             /** AAFCS7 ************************************/
             /** SEARCH SRT BY PART                        */
             /**********************************************/
             DCL        VAR(&SHN1  ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SHN2  ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SHN3  ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LOC1  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LOC2  ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LOC3  ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LOC4  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SRTN  ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&SRT#  ) TYPE(*CHAR) LEN(20)

             CHGVAR     VAR(&SHN1  ) VALUE('90105')
             CHGVAR     VAR(&SHN2  ) VALUE('A0120')
             CHGVAR     VAR(&SHN3  ) VALUE('  ')
             CHGVAR     VAR(&LOC1  ) VALUE('0')
             CHGVAR     VAR(&LOC2  ) VALUE('23')
             CHGVAR     VAR(&LOC3  ) VALUE('44')
             CHGVAR     VAR(&LOC4  ) VALUE('0')
             CHGVAR     VAR(&SRTN  ) VALUE('        ')
             CHGVAR     VAR(&SRT#  ) VALUE('        ')

             CALL       PGM(AAFRS7) PARM(&SHN1 &SHN2 &SHN3 &LOC1 +
                          &LOC2 &LOC3 &LOC4 &SRTN &SRT#)

             ENDPGM
