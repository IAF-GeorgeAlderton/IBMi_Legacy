             PGM
             /** UTLC51D ***************************************/
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

             CHGVAR     VAR(&NOHZ  ) VALUE('20250627')
             CHGVAR     VAR(&CUST  ) VALUE('5149')
             CHGVAR     VAR(&NONY  ) VALUE('5146')
             CHGVAR     VAR(&NKOJ  ) VALUE('0')
             CHGVAR     VAR(&NUKE  ) VALUE('XS  ')
             CHGVAR     VAR(&BINN  ) VALUE('01')
             CHGVAR     VAR(&RLHZ  ) VALUE('20250628')
             CHGVAR     VAR(&ODRN  ) VALUE('11111     ')

             CALL       PGM(UTLR51D) PARM(&NOHZ &CUST &NONY &NKOJ +
                          &NUKE &BINN &RLHZ &ODRN &PICK#)

             ENDPGM
