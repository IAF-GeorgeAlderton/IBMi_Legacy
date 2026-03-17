             PGM        PARM(&WKCD &USRID)

             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USRID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SECT) TYPE(*CHAR) LEN(2) VALUE('CV')

             CALL       PGM(IWAR78) PARM((&WKCD) (&USRID) (&SECT))

             ENDPGM
