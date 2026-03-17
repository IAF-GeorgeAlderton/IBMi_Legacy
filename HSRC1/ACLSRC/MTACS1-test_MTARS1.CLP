PGM
             DCL        VAR(&SDAT) TYPE(*DEC)  LEN(8 0) VALUE(20250401)
             DCL        VAR(&EDAT) TYPE(*DEC)  LEN(8 0) VALUE(20250430)
             DCL        VAR(&MCN ) TYPE(*CHAR) LEN(3)  VALUE('R28')
             DCL        VAR(&OUTS) TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&HOUR) TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&RPMH) TYPE(*DEC)  LEN(6 0)

             CALL       PGM(MTARS1) PARM(&SDAT &EDAT &MCN &OUTS +
                          &HOUR &RPMH)
ENDPGM
