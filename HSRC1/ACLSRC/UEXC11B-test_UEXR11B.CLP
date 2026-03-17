             /** UEXC11B **********************************************/
             /*  TEST - UEXR11B                                       */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&ODRN  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MHIN  ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&PLT   ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FIT   ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SR1C  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SR1D  ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SR1T  ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SR2C  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SR2D  ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SR2T  ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MRC   ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MRD   ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MRT   ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PODT  ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ECS   ) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&ODRN ) VALUE('A350000125')
             CHGVAR     VAR(&MHIN ) VALUE('808408080')

 CALL PGM(UEXR11B) PARM(&ODRN &MHIN &PLT &FIT &SR1C &SR1D &SR1T +
                        &SR2C &SR2D &SR2T &MRC &MRD &MRT &PODT &ECS)

             ENDPGM
