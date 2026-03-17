             PGM

             DCL        VAR(&END    ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&NONY   ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MHIN   ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&YTDQ   ) TYPE(*CHAR) LEN(9)

             CHGVAR     VAR(&END)  VALUE('20211231')
             CHGVAR     VAR(&NONY) VALUE('5152')
             CHGVAR     VAR(&MHIN) VALUE('W505425S442  ')
             CHGVAR     VAR(&YTDQ) VALUE(' ')

             CALL       PGM(UEXR41) PARM(&END  &NONY &MHIN &YTDQ)

             ENDPGM
