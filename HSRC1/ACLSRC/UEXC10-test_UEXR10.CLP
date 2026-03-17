             /** UEXC10 ***********************************************/
             /*  TEST - UEXR10                                        */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&NONY  ) TYPE(*CHAR) LEN(04)
             DCL        VAR(&ODRN  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MHINI ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&NOHZ  ) TYPE(*CHAR) LEN(08)
             DCL        VAR(&PLNT  ) TYPE(*CHAR) LEN(03)
             DCL        VAR(&SHCD  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLSH  ) TYPE(*CHAR) LEN(08)
             DCL        VAR(&QTY   ) TYPE(*CHAR) LEN(09)
             DCL        VAR(&MHINO ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&RTN   ) TYPE(*CHAR) LEN(01)

             CHGVAR     VAR(&NONY)  VALUE('3136')
             CHGVAR     VAR(&ODRN)  VALUE('1395330130')
             CHGVAR     VAR(&MHINI) VALUE('93913144G0   ')
             CHGVAR     VAR(&NOHZ)  VALUE('20200527')

             CALL       PGM(UEXR10) PARM(&NONY &ODRN &MHINI &NOHZ +
                          &PLNT &SHCD &PLSH &QTY &MHINO &RTN)

             ENDPGM
