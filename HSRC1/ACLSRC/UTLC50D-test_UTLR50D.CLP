             PGM
             /** UTLC50D ***************************************/
             /**************************************************/

             DCL        VAR(&NONY  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOHZ  ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MHIN  ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&ODRN  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN   ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&NONY  ) VALUE('5444')
             CHGVAR     VAR(&NKOJ  ) VALUE(' ')
             CHGVAR     VAR(&NUKE  ) VALUE('  ')
             CHGVAR     VAR(&NOHZ  ) VALUE('20240412')
             CHGVAR     VAR(&MHIN  ) VALUE('82113       ')
             CHGVAR     VAR(&ODRN  ) VALUE('NV9504 ')

             CALL       PGM(UTLR50D) PARM(&NONY &NKOJ &NUKE &NOHZ +
                          &MHIN &ODRN &RTN)

             ENDPGM
