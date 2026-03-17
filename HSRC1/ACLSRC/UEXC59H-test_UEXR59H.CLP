             PGM

             DCL        VAR(&SHID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&STT ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(6)

             CHGVAR     VAR(&SHID) VALUE('00513686')

             CALL PGM(UEXR59H ) PARM(&SHID &STT  &DATE &TIME)

             ENDPGM
