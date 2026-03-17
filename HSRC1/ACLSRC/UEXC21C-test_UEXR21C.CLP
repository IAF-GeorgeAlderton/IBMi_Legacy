             /*********************************************************/
             /*  TEST - UEXR21C                                       */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&NONY  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOHZ  ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&BIN   ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MHIN  ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&ORD   ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCN   ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&UNS   ) TYPE(*CHAR) LEN(6)

             CHGVAR     VAR(&NONY  )  VALUE('3611')
             CHGVAR     VAR(&NKOJ  )  VALUE('0')
             CHGVAR     VAR(&NUKE  )  VALUE('00  ')
             CHGVAR     VAR(&NOHZ  )  VALUE('20230720')
             CHGVAR     VAR(&BIN   )  VALUE('04')
             CHGVAR     VAR(&MHIN  )  VALUE('901000411  ')

             CALL       PGM(UEXR21C) PARM(&NONY &NKOJ &NUKE &NOHZ &BIN +
                          &MHIN &ORD &SCN &UNS)

             ENDPGM
