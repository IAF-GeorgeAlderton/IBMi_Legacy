             /** UEXC36BT *********************************************/
             /*  TEST -                                               */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&NONY  ) TYPE(*CHAR) LEN(4 )  VALUE('0567')
             DCL        VAR(&NKOJ  ) TYPE(*CHAR) LEN(1 )  VALUE('0')
             DCL        VAR(&NUKE  ) TYPE(*CHAR) LEN(4 )  VALUE('00  ')
             DCL        VAR(&NOHZ  ) TYPE(*CHAR) LEN(8 )  VALUE('20231204')
             DCL        VAR(&NOBN  ) TYPE(*CHAR) LEN(2 )  VALUE('01')
             DCL        VAR(&ODRN  ) TYPE(*CHAR) LEN(10)  VALUE('000038-1 ')
             DCL        VAR(&SERL  ) TYPE(*CHAR) LEN(20)  VALUE('    ')
             DCL        VAR(&TTAI  ) TYPE(*CHAR) LEN(10)  VALUE('    ')
             DCL        VAR(&RTN   ) TYPE(*CHAR) LEN(1 )  VALUE(' ')

             CALL       PGM(UEXR36B) PARM(&NONY &NKOJ &NUKE &NOHZ +
                          &NOBN &ODRN &SERL &TTAI &RTN)

             ENDPGM
