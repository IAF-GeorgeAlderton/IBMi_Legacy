             /** UEXC31F  *********************************************/
             /*  TEST -                                               */
             /*-------------------------------------------------------*/
             PGM

             DCL   VAR(&NONY  ) TYPE(*CHAR) LEN(4 )  VALUE('4126')
             DCL   VAR(&DATE  ) TYPE(*CHAR) LEN(8 )  VALUE('20251016')
             DCL   VAR(&BINI  ) TYPE(*CHAR) LEN(2 )  VALUE('05')
             DCL   VAR(&PLNT  ) TYPE(*CHAR) LEN(3 )  VALUE('MAP')
             DCL   VAR(&SHCD  ) TYPE(*CHAR) LEN(10)  VALUE('ANEXBU04  ')
             DCL   VAR(&BINO  ) TYPE(*CHAR) LEN(2 )

             CALL       PGM(UEXR31F) PARM(&NONY &DATE &BINI &PLNT &SHCD &BINO)

             ENDPGM
