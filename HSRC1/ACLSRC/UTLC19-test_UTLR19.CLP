             /** UTLC19  *****************************************/
             PGM

             DCL        VAR(&TM1  ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TM2  ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MIN  ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SIGN ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&TM1) VALUE('140000')
             CHGVAR     VAR(&TM2) VALUE('130000')

             CALL       PGM(UTLR19 ) PARM(&TM1 &TM2 &MIN &SIGN)

             ENDPGM
