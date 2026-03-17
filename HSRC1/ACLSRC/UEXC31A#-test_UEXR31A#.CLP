             /** UEXC31A# *********************************************/
             /*  TEST -                                               */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&NONY  ) TYPE(*CHAR) LEN(4 )  VALUE('4126')
             DCL        VAR(&PLSH  ) TYPE(*CHAR) LEN(8 )  VALUE('20250911')
             DCL        VAR(&BIN   ) TYPE(*CHAR) LEN(2 )  VALUE('05')
             DCL        VAR(&ODRN  ) TYPE(*CHAR) LEN(20)  VALUE('7888580010')
             DCL        VAR(&RTN   ) TYPE(*CHAR) LEN(1)

             CALL       PGM(UEXR31A#) PARM(&NONY &PLSH &BIN &ODRN &RTN)

             ENDPGM
