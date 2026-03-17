             /*********************************************************/
             /*  TEST - UEXR21B                                       */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&NONY  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOHZ  ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&BIN   ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SHIN  ) TYPE(*CHAR) LEN(12)
             DCL        VAR(&ODRN  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&UNS   ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RTN   ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&NONY  )  VALUE('3611')
             CHGVAR     VAR(&NKOJ  )  VALUE('0')
             CHGVAR     VAR(&NUKE  )  VALUE('00  ')
             CHGVAR     VAR(&NOHZ  )  VALUE('20230727')
             CHGVAR     VAR(&BIN   )  VALUE('04')
             CHGVAR     VAR(&SHIN  )  VALUE('9008011209  ')
             CHGVAR     VAR(&ODRN  )  VALUE('PD01630')

             CALL       PGM(UEXR21B) PARM(&NONY &NKOJ &NUKE &NOHZ &BIN +
                          &SHIN &ODRN &UNS &RTN)

             ENDPGM
