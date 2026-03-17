             PGM
             /** UTLC34F ***************************************/
             /**************************************************/
             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NUKE ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&POR# ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&ICCD ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&NONY ) VALUE('5152')
             CHGVAR     VAR(&NUKE ) VALUE('OW')
             CHGVAR     VAR(&POR# ) VALUE(' ')


             CALL       PGM(UTLR34F) PARM((&NONY) (&NUKE) (&POR#) +
                          (&ICCD) (&RTN))

             ENDPGM
