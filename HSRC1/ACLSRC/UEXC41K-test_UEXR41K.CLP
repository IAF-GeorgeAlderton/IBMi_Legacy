             PGM

             DCL        VAR(&NOHZ   ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&NONY   ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MHIN   ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&PLNT   ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&YTDQ   ) TYPE(*CHAR) LEN(9)

             CHGVAR     VAR(&NOHZ) VALUE('20260209')
             CHGVAR     VAR(&NONY) VALUE('5146')
             CHGVAR     VAR(&MHIN) VALUE('W500613S439')
             CHGVAR     VAR(&PLNT) VALUE(' ')
             CHGVAR     VAR(&YTDQ) VALUE(' ')

             CALL       PGM(UEXR41K) PARM(&NOHZ &NONY &MHIN &PLNT &YTDQ)

             ENDPGM
