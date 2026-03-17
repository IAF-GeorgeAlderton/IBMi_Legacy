             /** UEXC30A **********************************************/
             /*  TEST -                                               */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&NONY  ) TYPE(*CHAR) LEN(4  )  VALUE('0777')
             DCL        VAR(&NKOJ  ) TYPE(*CHAR) LEN(1  )  VALUE('0')
             DCL        VAR(&NUKE  ) TYPE(*CHAR) LEN(4  )  VALUE('IT  ')
             DCL        VAR(&NOHZ  ) TYPE(*CHAR) LEN(8  )  VALUE('20220819')
             DCL        VAR(&NOBN  ) TYPE(*CHAR) LEN(2  )  VALUE('01')
             DCL        VAR(&PGID  ) TYPE(*CHAR) LEN(12 )  VALUE('  ')
             DCL        VAR(&RAN#  ) TYPE(*CHAR) LEN(14 )  VALUE('  ')

             CALL       PGM(UEXR30A) PARM(&NONY &NKOJ &NUKE &NOHZ +
                          &NOBN &PGID &RAN#)

             ENDPGM
