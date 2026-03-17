             /** UEXC29D***********************************************/
             /*  TEST -                                               */
             /*-------------------------------------------------------*/
             PGM
             DCL        VAR(&NONY  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOHZ  ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&NOBN  ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&STS   ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&NONY)  VALUE('0579')
             CHGVAR     VAR(&NKOJ ) VALUE('0')
             CHGVAR     VAR(&NUKE ) VALUE('00')
             CHGVAR     VAR(&NOHZ ) VALUE('20240307')
             CHGVAR     VAR(&NOBN ) VALUE('10')
             CHGVAR     VAR(&STS  ) VALUE(' ')

             CALL       PGM(UEXR29D) PARM((&NONY) (&NKOJ) (&NUKE) +
                          (&NOHZ) (&NOBN) (&STS))

             ENDPGM
