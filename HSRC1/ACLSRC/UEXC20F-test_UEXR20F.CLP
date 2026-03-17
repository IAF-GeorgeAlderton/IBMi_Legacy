             /** UEXC20F **********************************************/
             /*  TEST - UEXR20F                                       */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&NONY  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MHIN  ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&NOHZ  ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ODRN  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&INVN  ) TYPE(*CHAR) LEN(16)
             DCL        VAR(&PRTR  ) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&NONY  )  VALUE('5444')
             CHGVAR     VAR(&MHIN  )  VALUE('82113 ')
             CHGVAR     VAR(&NOHZ  )  VALUE('20240712')
             CHGVAR     VAR(&ODRN  )  VALUE(' ')
             CHGVAR     VAR(&INVN  )  VALUE(' ')
             CHGVAR     VAR(&PRTR  )  VALUE(' ')

             CALL       PGM(HOBJ1/UEXR20F) PARM(&NONY &MHIN &NOHZ +
                          &ODRN &INVN &PRTR)

             ENDPGM
