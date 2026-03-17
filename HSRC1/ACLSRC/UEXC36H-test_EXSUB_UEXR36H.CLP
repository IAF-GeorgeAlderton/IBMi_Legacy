             /** UEXC36H  *********************************************/
             /*  TEST -                                               */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&PCK   ) TYPE(*CHAR) LEN(9 )  VALUE('240600756')
             DCL        VAR(&MAST  ) TYPE(*CHAR) LEN(20)

             CALL       PGM(UEXR36H) PARM(&PCK  &MAST)

             ENDPGM
