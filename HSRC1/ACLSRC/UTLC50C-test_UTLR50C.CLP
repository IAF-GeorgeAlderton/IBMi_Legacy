             PGM
             /** UTLC50C ***************************************/
             /**************************************************/

             DCL        VAR(&NONY  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOHZ  ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MHIN  ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&ODRN  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&INVN  ) TYPE(*CHAR) LEN(16)
             DCL        VAR(&RTN   ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&NONY  ) VALUE('0794')
             CHGVAR     VAR(&NKOJ  ) VALUE('0')
             CHGVAR     VAR(&NUKE  ) VALUE('S1')
             CHGVAR     VAR(&NOHZ  ) VALUE('20231116')
             CHGVAR     VAR(&MHIN  ) VALUE('98123106002 ')
             CHGVAR     VAR(&ODRN  ) VALUE('1      ')
             CHGVAR     VAR(&INVN  ) VALUE('202311230000S1')
             CHGVAR     VAR(&RTN   ) VALUE(' ')

             CALL       PGM(UTLR50C) PARM(&NONY &NKOJ &NUKE &NOHZ +
                          &MHIN &ODRN &INVN &RTN)

             ENDPGM
