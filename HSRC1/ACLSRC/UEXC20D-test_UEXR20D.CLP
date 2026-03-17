             /** UEXC20D **********************************************/
             /*  TEST - UEXR20D                                       */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&NONY  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOHZ  ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&BIN   ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PL#   ) TYPE(*CHAR) LEN(9)
             DCL        VAR(&PO#   ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PTYP  ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&NONY  )  VALUE('0579')
             CHGVAR     VAR(&NKOJ  )  VALUE('0')
             CHGVAR     VAR(&NUKE  )  VALUE('00  ')
             CHGVAR     VAR(&NOHZ  )  VALUE('20241010')
             CHGVAR     VAR(&BIN   )  VALUE('02')
             CHGVAR     VAR(&PL#   )  VALUE('         ')
             CHGVAR     VAR(&PO#   )  VALUE(' ')
             CHGVAR     VAR(&PTYP  )  VALUE(' ')

             CALL       PGM(HOBJ1/UEXR20D) PARM(&NONY &NKOJ &NUKE +
                          &NOHZ &BIN &PL# &PO# &PTYP)

             ENDPGM
