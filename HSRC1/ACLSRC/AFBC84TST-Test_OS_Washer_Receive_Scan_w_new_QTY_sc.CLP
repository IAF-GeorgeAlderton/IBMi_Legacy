             PGM
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKCD)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&END)  TYPE(*CHAR) LEN(1)

             RTVJOBA    USER(&USER)

             CALL       PGM(AFBR8W) PARM(&WKCD &END)

             IF         COND(&END *EQ ' ') THEN(DO)
             OVRDSPF    FILE(AFBPW84) TOFILE(TOBJ1/AFBPW84)
             CALL       PGM(TOBJ1/AFBR84) PARM((&USER) (&WKCD))
             ENDDO

             SIGNOFF

             ENDPGM
