             /** UEXC31B# *********************************************/
             /*  TEST -                                               */
             /*-------------------------------------------------------*/
             PGM

             DCL   VAR(&NONY  ) TYPE(*CHAR) LEN(4 )  VALUE('4126')
             DCL   VAR(&PLSH  ) TYPE(*CHAR) LEN(8 )  VALUE('20250912')
             DCL   VAR(&BIN1  ) TYPE(*CHAR) LEN(2 )  VALUE('00')
             DCL   VAR(&ODRN  ) TYPE(*CHAR) LEN(20)  VALUE('7888580010')
             DCL   VAR(&BIN2  ) TYPE(*CHAR) LEN(2)

             CALL  PGM(UEXR31B#) PARM(&NONY &PLSH &BIN1 &ODRN &BIN2)

             ENDPGM
