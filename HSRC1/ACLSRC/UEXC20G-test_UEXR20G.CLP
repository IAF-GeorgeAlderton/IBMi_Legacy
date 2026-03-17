             /** UEXC20G **********************************************/
             /*  TEST - UEXR20G                                       */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&NONY  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MHIN  ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&NOHZ  ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PO#   ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&SLOC  ) TYPE(*CHAR) LEN(20)

             CHGVAR     VAR(&NONY  )  VALUE('0777')
             CHGVAR     VAR(&MHIN  )  VALUE('99135180618')
             CHGVAR     VAR(&NOHZ  )  VALUE('20250702')
             CHGVAR     VAR(&PO#   )  VALUE('214613-1584-23')

             CALL       PGM(HOBJ1/UEXR20G) PARM(&NONY &NOHZ &MHIN +
                          &PO#  &SLOC)

             ENDPGM
