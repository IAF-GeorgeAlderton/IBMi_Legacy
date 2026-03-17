             /** UEXC31T **********************************************/
             /*  TEST -                                               */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&NONY  ) TYPE(*CHAR) LEN(4 )  VALUE('0286')
             DCL        VAR(&PLSH  ) TYPE(*CHAR) LEN(8 )  VALUE('20200630')
             DCL        VAR(&BIN   ) TYPE(*CHAR) LEN(2 )  VALUE('01')
             DCL        VAR(&MHN1  ) TYPE(*CHAR) LEN(5 )  VALUE('90001')
             DCL        VAR(&MHN2  ) TYPE(*CHAR) LEN(5 )  VALUE('S10A0')
             DCL        VAR(&MHN3  ) TYPE(*CHAR) LEN(5 )  VALUE('00  ')
             DCL        VAR(&MHN4  ) TYPE(*CHAR) LEN(5 )  VALUE('    ')
             DCL        VAR(&ODRN  ) TYPE(*CHAR) LEN(20)  VALUE('966565  ')
             DCL        VAR(&RTN   ) TYPE(*CHAR) LEN(1 )  VALUE(' ')

             CALL       PGM(UEXR31) PARM(&NONY &PLSH &BIN  &MHN1 +
                          &MHN2 &MHN3 &MHN4 &ODRN &RTN)

             ENDPGM
