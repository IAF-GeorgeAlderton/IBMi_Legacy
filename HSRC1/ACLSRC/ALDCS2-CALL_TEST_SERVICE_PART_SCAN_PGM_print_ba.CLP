             PGM

             DCL        VAR(&WKCD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USR10) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR20) TYPE(*CHAR) LEN(10)
             DCL        VAR(&VALID) TYPE(*CHAR) LEN(1)

             CALL       PGM(ALCR0Y) PARM(&WKCD &USR10 &VALID)
             CHGVAR     VAR(&USR20) VALUE(&USR10)
             IF         COND(&VALID *EQ 'Y') THEN(CALL PGM(ALDR2SNW) +
                          PARM(&WKCD &USR20))

             SIGNOFF

             ENDPGM
