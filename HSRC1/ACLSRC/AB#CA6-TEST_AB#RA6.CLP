             PGM

             DCL        VAR(&NONY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOHZ) TYPE(*DEC ) LEN(8 0)
             DCL        VAR(&NOBN) TYPE(*DEC ) LEN(2 0)
             DCL        VAR(&REHZ) TYPE(*DEC ) LEN(8 0)
             DCL        VAR(&FLG ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&NONY) VALUE('5100')
             CHGVAR     VAR(&NKOJ) VALUE('0')
             CHGVAR     VAR(&NUKE) VALUE('00')
             CHGVAR     VAR(&NOHZ) VALUE(20241118)
             CHGVAR     VAR(&NOBN) VALUE(02)
             CHGVAR     VAR(&REHZ) VALUE(20241118)
             CHGVAR     VAR(&FLG ) VALUE(' ')

             CALL AB#RA6 PARM(&NONY &NKOJ &NUKE &NOHZ &NOBN &REHZ &FLG)

             ENDPGM
