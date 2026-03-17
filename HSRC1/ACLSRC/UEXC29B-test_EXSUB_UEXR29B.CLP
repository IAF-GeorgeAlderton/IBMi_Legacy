             /** UEXC29B***********************************************/
             /*  TEST -                                               */
             /*-------------------------------------------------------*/
             PGM
             DCL        VAR(&NONY  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOHZ  ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&NOBN  ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MHIN  ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&ODRN  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN   ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&NONY)  VALUE('4126')
             CHGVAR     VAR(&NKOJ ) VALUE('0')
             CHGVAR     VAR(&NUKE ) VALUE('00')
             CHGVAR     VAR(&NOHZ ) VALUE('20231201')
             CHGVAR     VAR(&NOBN ) VALUE('01')
             CHGVAR     VAR(&MHIN ) VALUE('90104T0AA010M1')
             CHGVAR     VAR(&ODRN ) VALUE('295363')
             CHGVAR     VAR(&RTN  ) VALUE(' ')

             CALL       PGM(UEXR29B) PARM(&NONY &NKOJ &NUKE &NOHZ +
                          &NOBN &MHIN &ODRN &RTN)

             ENDPGM
