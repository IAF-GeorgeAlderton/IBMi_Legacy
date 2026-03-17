             /** UEXC36J  *********************************************/
             /*  TEST -                                               */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&NONY  ) TYPE(*CHAR) LEN(4 )  VALUE('5426')
             DCL        VAR(&NKOJ  ) TYPE(*CHAR) LEN(1 )  VALUE('0')
             DCL        VAR(&NUKE  ) TYPE(*CHAR) LEN(4 )  VALUE('00  ')
             DCL        VAR(&NOHZ  ) TYPE(*CHAR) LEN(8 )  VALUE('20240919')
             DCL        VAR(&NOBN  ) TYPE(*CHAR) LEN(2 )  VALUE('02')
             DCL        VAR(&ODRN  ) TYPE(*CHAR) LEN(10)  VALUE('21341128  ')
             DCL        VAR(&MHIN  ) TYPE(*CHAR) LEN(20)  VALUE('9008017248K')
             DCL        VAR(&SERL  ) TYPE(*CHAR) LEN(20)  VALUE(' ')

             CALL       PGM(UEXR36J) PARM(&NONY &NKOJ &NUKE &NOHZ +
                          &NOBN &ODRN &MHIN &SERL )

             ENDPGM
