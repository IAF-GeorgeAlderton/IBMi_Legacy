             /** UEXC09 ***********************************************/
             /*  TEST - UEXR09                                        */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&PLNT  ) TYPE(*CHAR) LEN(03)
             DCL        VAR(&SHCD  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOKU  ) TYPE(*CHAR) LEN(04)
             DCL        VAR(&NONY  ) TYPE(*CHAR) LEN(04)

             CHGVAR     VAR(&PLNT) VALUE('AHM')
             CHGVAR     VAR(&SHCD) VALUE('YY        ')

             CALL       PGM(UEXR09A) PARM(&PLNT &SHCD &TOKU &NONY)

             ENDPGM
