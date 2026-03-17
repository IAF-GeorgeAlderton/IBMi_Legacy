             PGM

             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)

             OVRDBF     FILE(ABFJP01) TOFILE(TFILE1/ABFJP01)

             CALL       PGM(AB#RF@) PARM(&RTN)

             ENDPGM
