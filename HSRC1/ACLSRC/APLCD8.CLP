             PGM

             DCL        VAR(&GET) TYPE(*CHAR) LEN(256)
             DCL        VAR(&AB951W0) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&GET) VALUE('C:/AS400/DATA/GETQR.TXT')

             CALL       PGM(APLCD9) PARM(&GET &AB951W0)

             EDTDTA     FILE(&AB951W0)

             ENDPGM
