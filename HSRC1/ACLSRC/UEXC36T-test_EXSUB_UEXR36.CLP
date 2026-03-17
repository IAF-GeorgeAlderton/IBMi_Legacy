             /** UEXC36T **********************************************/
             /*  TEST -                                               */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&NONY  ) TYPE(*CHAR) LEN(4 )  VALUE('6022')
             DCL        VAR(&NKOJ  ) TYPE(*CHAR) LEN(1 )  VALUE('0')
             DCL        VAR(&NUKE  ) TYPE(*CHAR) LEN(4 )  VALUE('00  ')
             DCL        VAR(&NOHZ  ) TYPE(*CHAR) LEN(8 )  VALUE('20211129')
             DCL        VAR(&NOBN  ) TYPE(*CHAR) LEN(2 )  VALUE('27')
             DCL        VAR(&ODRN  ) TYPE(*CHAR) LEN(10)  VALUE('016177   ')
             DCL        VAR(&SERL  ) TYPE(*CHAR) LEN(20)  VALUE('    ')
             DCL        VAR(&TTAI  ) TYPE(*CHAR) LEN(10)  VALUE('    ')
             DCL        VAR(&PAL   ) TYPE(*CHAR) LEN(2 )  VALUE('  ')
             DCL        VAR(&RTN   ) TYPE(*CHAR) LEN(1 )  VALUE(' ')

             CALL       PGM(UEXR36) PARM(&NONY &NKOJ &NUKE &NOHZ +
                          &NOBN &ODRN &SERL &TTAI &PAL &RTN)

             ENDPGM
