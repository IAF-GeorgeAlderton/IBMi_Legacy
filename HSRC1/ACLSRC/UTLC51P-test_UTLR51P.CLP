             PGM        PARM(&NOHZ &BINN &ODRN)
             /** UTLC51P ***************************************/
             /**************************************************/

             DCL        VAR(&NONY  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOHZ  ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&BINN  ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ODRN  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RLHZ  ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN   ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&NONY  ) VALUE('0777')
             CHGVAR     VAR(&NKOJ  ) VALUE('0')
             CHGVAR     VAR(&NUKE  ) VALUE('    ')
             CHGVAR     VAR(&RLHZ  ) VALUE('00000000')

             CALL       PGM(UTLR51P) PARM(&NONY &NKOJ +
                          &NUKE &NOHZ &BINN &RLHZ &ODRN &RTN)

             ENDPGM
