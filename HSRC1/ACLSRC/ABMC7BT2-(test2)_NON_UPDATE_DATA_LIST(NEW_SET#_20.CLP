             PGM

             DCL        VAR(&P@NTYM) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&PRTG@) TYPE(*CHAR) LEN(10)
/*TEST*/
             CHGVAR     VAR(&P@NTYM) VALUE(202001)
             CHGVAR     VAR(&PRTG@) VALUE('EPRINT1 ')

             CALL       PGM(ABMC7B) PARM(&P@NTYM &PRTG@)

             ENDPGM
