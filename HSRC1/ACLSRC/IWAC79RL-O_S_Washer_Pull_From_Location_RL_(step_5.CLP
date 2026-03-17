             PGM        PARM(&WKCD &USRID)

             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USRID) TYPE(*CHAR) LEN(20)
             DCL        VAR(&SECT) TYPE(*CHAR) LEN(2) VALUE('RL')

             CALL       PGM(IWAR79) PARM((&WKCD) (&USRID) (&SECT))

             ENDPGM
