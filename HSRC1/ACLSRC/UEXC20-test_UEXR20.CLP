             /** UEXC11 ***********************************************/
             /*  TEST - UEXR11                                        */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&NONY  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NUKE  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOHZ  ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&BIN   ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MHIN  ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&INVN  ) TYPE(*CHAR) LEN(16)
             DCL        VAR(&RAN#  ) TYPE(*CHAR) LEN(12)
             DCL        VAR(&ODRN  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN   ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&NONY  )  VALUE('0492')
             CHGVAR     VAR(&NUKE  )  VALUE('P3  ')
             CHGVAR     VAR(&NOHZ  )  VALUE('20200227')
             CHGVAR     VAR(&BIN   )  VALUE('03')
             CHGVAR     VAR(&MHIN  )  VALUE('9011910A014')
             CHGVAR     VAR(&INVN  )  VALUE('0000057441')
             CHGVAR     VAR(&RAN#  )  VALUE(' ')
             CHGVAR     VAR(&ODRN  )  VALUE(' ')
             CHGVAR     VAR(&RTN   )  VALUE(' ')

             CALL       PGM(UEXR20) PARM(&NONY &NUKE &NOHZ &BIN +
                          &MHIN &INVN &RAN# &ODRN &RTN)

             ENDPGM
