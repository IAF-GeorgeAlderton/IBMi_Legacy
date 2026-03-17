             PGM

             DCL        VAR(&SHN1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SHN2) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SHN3) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ORD ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SDAT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&STIM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&STK ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&SHN1) VALUE('90105')
             CHGVAR     VAR(&SHN2) VALUE('A0259')
             CHGVAR     VAR(&SHN3) VALUE(' ')
             CHGVAR     VAR(&ORD ) VALUE('336')
             CHGVAR     VAR(&SDAT) VALUE(' ')
             CHGVAR     VAR(&STIM) VALUE(' ')
             CHGVAR     VAR(&STK ) VALUE(' ')

             CALL       PGM(ALCRS5) PARM(&SHN1 &SHN2 &SHN3 &ORD +
                          &SDAT &STIM &STK &RTN)

             ENDPGM
