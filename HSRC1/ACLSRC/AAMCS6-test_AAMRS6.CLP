PGM
/** TEST CLP **/

             DCL        VAR(&PIHIN1 ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PIHIN2 ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PIHIN3 ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PIBMON ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PIKOTE ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PIKIBN ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PIBAN1 ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PIBAN2 ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PIBAN3 ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PIBAN4 ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PIDATE ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PIBIN  ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&POBMON ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&POKOTE ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&POKIBN ) TYPE(*CHAR) LEN(3)

             CHGVAR     VAR(&PIHIN1 ) VALUE('90080')
             CHGVAR     VAR(&PIHIN2 ) VALUE('11699')
             CHGVAR     VAR(&PIHIN3 ) VALUE('  ')
             CHGVAR     VAR(&PIBMON ) VALUE('0111')
             CHGVAR     VAR(&PIKOTE ) VALUE('BZ ')
             CHGVAR     VAR(&PIKIBN ) VALUE('D01')
             CHGVAR     VAR(&PIBAN1 ) VALUE('1')
             CHGVAR     VAR(&PIBAN2 ) VALUE('Q1')
             CHGVAR     VAR(&PIBAN3 ) VALUE('01')
             CHGVAR     VAR(&PIBAN4 ) VALUE('0')
             CHGVAR     VAR(&PIDATE ) VALUE('20191213')
             CHGVAR     VAR(&PIBIN  ) VALUE('01')

             CALL       PGM(AAMRS6) PARM(&PIHIN1 &PIHIN2 &PIHIN3 +
                          &PIBMON &PIKOTE &PIKIBN &PIBAN1 &PIBAN2 +
                          &PIBAN3 &PIBAN4 &PIDATE &PIBIN &POBMON +
                          &POKOTE &POKIBN)



ENDPGM
