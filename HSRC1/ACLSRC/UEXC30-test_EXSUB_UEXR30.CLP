             /** UEXC30 ***********************************************/
             /*  TEST -                                               */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&NONY  ) TYPE(*DEC ) LEN(4 0)  VALUE(0647)
             DCL        VAR(&NKOJ  ) TYPE(*CHAR) LEN(1  )  VALUE('0')
             DCL        VAR(&NUKE  ) TYPE(*CHAR) LEN(4  )  VALUE('00  ')
             DCL        VAR(&SHFM  ) TYPE(*DEC ) LEN(8 0)  VALUE(20200409)
             DCL        VAR(&SHTO  ) TYPE(*DEC ) LEN(8 0)  VALUE(99999999)
             DCL        VAR(&NOBN  ) TYPE(*CHAR) LEN(2  )  VALUE('01')
             DCL        VAR(&ODRN  ) TYPE(*CHAR) LEN(10 )  VALUE('IAF-032020')
             DCL        VAR(&INVN  ) TYPE(*CHAR) LEN(16 )  VALUE('        ')
             DCL        VAR(&QTY   ) TYPE(*DEC ) LEN(5 0)  VALUE(0)

             CALL       PGM(UEXR30) PARM(&NONY &NKOJ &NUKE &SHFM +
                          &SHTO &NOBN &ODRN &INVN &QTY)

             ENDPGM
