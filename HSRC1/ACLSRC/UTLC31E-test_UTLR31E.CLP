             PGM
             /** UTLC31E ***************************************/
             /**************************************************/
             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MHIN ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&NAME ) TYPE(*CHAR) LEN(15)

             CHGVAR     VAR(&NONY ) VALUE('5917')
             CHGVAR     VAR(&MHIN ) VALUE('90105A0068')


             CALL       PGM(UTLR31E) PARM((&NONY) (&MHIN) (&NAME))

             ENDPGM
