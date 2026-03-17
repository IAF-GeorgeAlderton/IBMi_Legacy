             /** UTLC03B  ****************************************/
             /*  UTILITY - TEST UTLR03B                          */
             /*--------------------------------------------------*/
             PGM

             DCL        VAR(&DATE ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&TOKU ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&CPART) TYPE(*CHAR) LEN(20)
             DCL        VAR(&UP   ) TYPE(*CHAR) LEN(9)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&DATE)  VALUE(' ')
             CHGVAR     VAR(&TOKU ) VALUE('3411')
             CHGVAR     VAR(&NONY ) VALUE('3851')
             CHGVAR     VAR(&CPART) VALUE('90105A0484  ')

             CALL       PGM(HOBJ1/UTLR03B) PARM((&DATE) (&TOKU) +
                          (&NONY) (&CPART) (&UP) (&RTN))

 END:        ENDPGM
