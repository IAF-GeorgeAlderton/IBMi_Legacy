             PGM
             /** FBCC10 ******************************/
             /*  TEST FBCR10                         */
             /*  JW   2023.09.26                     */
             /****************************************/

             DCL        VAR(&TOKU ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MHIN ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&NOHZ ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&TANK ) TYPE(*DEC) LEN(10 5)
             DCL        VAR(&CHEK ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&TOKU ) VALUE('3411')
             CHGVAR     VAR(&NONY ) VALUE('3851')
             CHGVAR     VAR(&NKOJ ) VALUE('0')
             CHGVAR     VAR(&NUKE ) VALUE('G1  ')
             CHGVAR     VAR(&MHIN ) VALUE('90105A048400')
             CHGVAR     VAR(&NOHZ ) VALUE('20250103')
             CHGVAR     VAR(&TANK ) VALUE(0)
             CHGVAR     VAR(&CHEK ) VALUE(' ')

             CALL       PGM(TOBJ1/FBCR10) PARM(&TOKU &NONY &NKOJ +
                          &NUKE &MHIN &NOHZ &TANK &CHEK)

             ENDPGM
