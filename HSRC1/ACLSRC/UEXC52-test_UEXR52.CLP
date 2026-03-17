             PGM
             /** UEXC52  **********************************************/
             /*  TEST UEXR50                                          */
             /*-------------------------------------------------------*/
             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&DATE ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&NONY) VALUE('3770')
             CHGVAR     VAR(&DATE) VALUE('20240502')

             CALL       PGM(UEXR52) PARM(&NONY &DATE &RTN)

             ENDPGM
