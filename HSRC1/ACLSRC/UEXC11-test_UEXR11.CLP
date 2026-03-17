             /** UEXC11 ***********************************************/
             /*  TEST - UEXR11                                        */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&NONY  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SHPDT ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&BIN1  ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&BIN2  ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTN   ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&NONY ) VALUE('3611')
             CHGVAR     VAR(&SHPDT) VALUE('20190731')
             CHGVAR     VAR(&BIN1 ) VALUE('04')

             CALL       PGM(UEXR11) PARM(&NONY &SHPDT &BIN1 &BIN2 &RTN)

             ENDPGM
