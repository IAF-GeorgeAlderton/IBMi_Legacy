             /** UTLC05 ******************************************/
             /*  UTILITY - GET PREVIOUS LOCATION BY CURRENT LOC  */
             /****************************************************/
             PGM

             DCL        VAR(&LOC  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SHN1 ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SHN2 ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SHN3 ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PLOC ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&LOC)  VALUE('X008')
             CHGVAR     VAR(&SHN1) VALUE('U1619')
             CHGVAR     VAR(&SHN2) VALUE('C1067')
             CHGVAR     VAR(&SHN3) VALUE('  ')

             CALL       PGM(UTLR05) PARM(&LOC &SHN1 &SHN2 &SHN3 &PLOC &RTN)

 END:        ENDPGM
