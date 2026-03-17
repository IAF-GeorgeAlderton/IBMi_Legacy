             /** UEXC09 ***********************************************/
             /*  TEST - UEXR09                                        */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&ODRN  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NOHZ  ) TYPE(*CHAR) LEN(08)
             DCL        VAR(&PLNT  ) TYPE(*CHAR) LEN(03)
             DCL        VAR(&SHCD  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN   ) TYPE(*CHAR) LEN(01)

             CHGVAR     VAR(&ODRN) VALUE('907705')
             CHGVAR     VAR(&NOHZ) VALUE('20190606')

             CALL       PGM(UEXR09) PARM(&ODRN &NOHZ &PLNT &SHCD &RTN)

             ENDPGM
