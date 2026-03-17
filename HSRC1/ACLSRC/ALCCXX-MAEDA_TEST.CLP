             PGM
             DCL        VAR(&N1) TYPE(*DEC) LEN(3 0) VALUE(016)
             DCL        VAR(&N2) TYPE(*DEC) LEN(8 0) VALUE(20210323)
             DCL        VAR(&N3) TYPE(*DEC) LEN(6 0) VALUE(150000)
             DCL        VAR(&N4) TYPE(*DEC) LEN(8 0) VALUE(0)
             DCL        VAR(&N5) TYPE(*DEC) LEN(6 0) VALUE(0)
             CALL       PGM(ALCRS4) PARM('90080' '11699' ' ' '991' +
                          '01' &N1 &N2 &N3 &N4 &N5)

             ENDPGM
