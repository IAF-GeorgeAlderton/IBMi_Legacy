             /** UEXC29C***********************************************/
             /*  TEST -                                               */
             /*-------------------------------------------------------*/
             PGM
             DCL        VAR(&NONY  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOHZ  ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&NOBN  ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTN   ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&NONY)  VALUE('5672')
             CHGVAR     VAR(&NKOJ ) VALUE(' ')
             CHGVAR     VAR(&NUKE ) VALUE('  ')
             CHGVAR     VAR(&NOHZ ) VALUE('20240110')
             CHGVAR     VAR(&NOBN ) VALUE('01')
             CHGVAR     VAR(&RTN  ) VALUE(' ')

             CALL       PGM(UEXR29C) PARM((&NONY) (&NKOJ) (&NUKE) +
                          (&NOHZ) (&NOBN) (&RTN))

             ENDPGM
