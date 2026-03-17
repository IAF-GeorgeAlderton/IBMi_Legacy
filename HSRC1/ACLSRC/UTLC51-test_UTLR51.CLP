             PGM
             /** UTLC51 ****************************************/
             /**************************************************/

             DCL        VAR(&NOHZ  ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CUST  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NONY  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&BINN  ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RLHZ  ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ODRN  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PICK# ) TYPE(*CHAR) LEN(9)
             DCL        VAR(&RTN   ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&NOHZ  ) VALUE('20240801')
             CHGVAR     VAR(&CUST  ) VALUE('5149')
             CHGVAR     VAR(&NONY  ) VALUE('5126')
             CHGVAR     VAR(&NKOJ  ) VALUE('0')
             CHGVAR     VAR(&NUKE  ) VALUE('00  ')
             CHGVAR     VAR(&BINN  ) VALUE('60')
             CHGVAR     VAR(&RLHZ  ) VALUE('20240801')
             CHGVAR     VAR(&ODRN  ) VALUE('11111     ')
             CHGVAR     VAR(&PICK# ) VALUE('  ')
             CHGVAR     VAR(&RTN   ) VALUE('  ')

             CALL       PGM(UTLR51) PARM(&NOHZ &CUST &NONY &NKOJ +
                          &NUKE &BINN &RLHZ &ODRN &PICK# &RTN)

             ENDPGM
