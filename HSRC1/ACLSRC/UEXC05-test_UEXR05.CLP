             /** UEXC05  **********************************************/
             /*  TEST - UEXR05                                        */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&SHN   ) TYPE(*CHAR) LEN(12)
             DCL        VAR(&DPT   ) TYPE(*CHAR) LEN(60)
             DCL        VAR(&MCN   ) TYPE(*CHAR) LEN(45)
             DCL        VAR(&LOC   ) TYPE(*CHAR) LEN(90)
             DCL        VAR(&TYP   ) TYPE(*CHAR) LEN(15)
             DCL        VAR(&PRC   ) TYPE(*CHAR) LEN(45)
             DCL        VAR(&PRT   ) TYPE(*CHAR) LEN(180)
             DCL        VAR(&STS   ) TYPE(*CHAR) LEN(01)

             CHGVAR     VAR(&SHN ) VALUE('9008010385')
             CHGVAR     VAR(&DPT ) VALUE(' ')
             CHGVAR     VAR(&MCN ) VALUE(' ')
             CHGVAR     VAR(&LOC ) VALUE(' ')
             CHGVAR     VAR(&TYP ) VALUE(' ')
             CHGVAR     VAR(&PRC ) VALUE(' ')
             CHGVAR     VAR(&PRT ) VALUE(' ')
             CHGVAR     VAR(&STS ) VALUE(' ')

             CALL       PGM(UEXR05) PARM(&SHN &DPT &MCN &LOC &TYP +
                          &PRC &PRT &STS)

             ENDPGM
