             PGM

             DCL        VAR(&PTOKU) TYPE(*DEC) LEN(4 0) VALUE(3411)
             DCL        VAR(&PNONY) TYPE(*DEC) LEN(4 0) VALUE(3804)
             DCL        VAR(&PNUKE) TYPE(*CHAR) LEN(4) VALUE('ML')
             DCL        VAR(&PSHDT) TYPE(*DEC) LEN(8 0) VALUE(20230619)
             DCL        VAR(&PSLIDE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PSLDT) TYPE(*DEC) LEN(8 0)

             CALL       PGM(AB#RSLI) PARM(&PTOKU &PNONY &PNUKE +
                          &PSHDT &PSLIDE &PSLDT)

             ENDPGM
