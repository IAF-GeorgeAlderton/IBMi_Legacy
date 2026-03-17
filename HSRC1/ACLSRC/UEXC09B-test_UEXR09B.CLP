             /** UEXC09B **********************************************/
             /*  TEST - UEXR09B                                       */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&NONY  ) TYPE(*CHAR) LEN(04)
             DCL        VAR(&ODRN  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLNT  ) TYPE(*CHAR) LEN(03)
             DCL        VAR(&SHCD  ) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&NONY) VALUE('0294')
             CHGVAR     VAR(&ODRN) VALUE('0283210010')

             CALL       PGM(UEXR09B) PARM(&NONY &ODRN &PLNT &SHCD)

             ENDPGM
