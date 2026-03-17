             PGM

             DCL        VAR(&PL  ) TYPE(*CHAR) LEN(9)
             DCL        VAR(&AUTH) TYPE(*CHAR) LEN(20)

             CHGVAR     VAR(&PL  ) VALUE('999     ')

             CALL       PGM(UEXR57A) PARM(&PL &AUTH)

             ENDPGM
