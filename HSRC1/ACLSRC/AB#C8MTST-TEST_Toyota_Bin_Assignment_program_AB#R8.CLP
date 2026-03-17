             PGM

             DCL        VAR(&SHDT)  TYPE(*DEC)  LEN(8 0)
             DCL        VAR(&ROUT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BIN) TYPE(*DEC) LEN(2 0)

             CHGVAR     VAR(&SHDT) VALUE(20180807)
             CHGVAR     VAR(&ROUT) VALUE('SYIA02')

             CALL       PGM(AB#R8M) PARM(&SHDT &ROUT &BIN)

             ENDPGM
