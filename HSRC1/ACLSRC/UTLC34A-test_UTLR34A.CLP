             PGM
             /** UTLC34A ***************************************/
             /**************************************************/
             DCL        VAR(&PLNT ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&DOCK ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&PLNT ) VALUE('TC11A')
             CHGVAR     VAR(&DOCK ) VALUE('  ')


             CALL       PGM(UTLR34A) PARM(&PLNT &DOCK &NONY &RTN)

             ENDPGM
