             PGM

             DCL        VAR(&PL  ) TYPE(*CHAR) LEN(9)
             DCL        VAR(&SHID) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&PL )  VALUE('250105614')
             CHGVAR     VAR(&SHID) VALUE('111111111')

             CLRPFM     FILE(TFILE1/AB#EP61)
             CLRPFM     FILE(TFILE1/AB#EP62)

             OVRDBF     FILE(AB#EP61) TOFILE(TFILE1/AB#EP61)
             OVRDBF     FILE(AB#EP62) TOFILE(TFILE1/AB#EP62)

             CALL       PGM(UEXR55 ) PARM(&PL &SHID)

             ENDPGM
