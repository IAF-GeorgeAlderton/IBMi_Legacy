PGM
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(256) VALUE('AAAA')
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(10) VALUE('APLC9C')


             CALL       PGM(APLR9C) PARM(&PGM &MSG)





ENDPGM
