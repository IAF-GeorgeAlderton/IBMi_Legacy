             PGM

             DCL        VAR(&SHIN ) TYPE(*CHAR) LEN(12)
             DCL        VAR(&ZETI ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&FPRC ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FDPT ) TYPE(*DEC)  LEN(4 0)
             DCL        VAR(&FMCN ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FSIZE) TYPE(*CHAR) LEN(3)
             DCL        VAR(&LLOC ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&QPC  ) TYPE(*DEC ) LEN(6 0)
             DCL        VAR(&MSET ) TYPE(*DEC ) LEN(9 0)
             DCL        VAR(&DSVB ) TYPE(*DEC ) LEN(6 1)
             DCL        VAR(&DSVQ ) TYPE(*DEC ) LEN(8 0)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             DCL        VAR(&MSET2) TYPE(*DEC ) LEN(9 0)
             DCL        VAR(&DSVB2) TYPE(*DEC ) LEN(6 1)
             DCL        VAR(&DSVQ2) TYPE(*DEC ) LEN(8 0)

             DCL        VAR(&FLOC1) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FLOC2) TYPE(*CHAR) LEN(6)

             CHGVAR     VAR(&SHIN)  VALUE('U0679B0053 ')
             CHGVAR     VAR(&ZETI ) VALUE(' ')
             CHGVAR     VAR(&FPRC ) VALUE(' ')
             CHGVAR     VAR(&FDPT ) VALUE(0)
             CHGVAR     VAR(&FMCN ) VALUE(' ')
             CHGVAR     VAR(&FSIZE) VALUE(' ')
             CHGVAR     VAR(&LLOC ) VALUE(' ')
             CHGVAR     VAR(&QPC  ) VALUE(0)
             CHGVAR     VAR(&MSET ) VALUE(0)
             CHGVAR     VAR(&DSVB ) VALUE(0)
             CHGVAR     VAR(&DSVQ ) VALUE(0)
             CHGVAR     VAR(&RTN  ) VALUE(' ')

             CHGVAR     VAR(&MSET ) VALUE(0)
             CHGVAR     VAR(&DSVB ) VALUE(0)
             CHGVAR     VAR(&DSVQ ) VALUE(0)

             CHGVAR     VAR(&FLOC1) VALUE(' ')
             CHGVAR     VAR(&FLOC2) VALUE(' ')

             CALL       PGM(UTLR78E) PARM(&SHIN &ZETI &FPRC &FDPT +
                          &FMCN &FLOC1 &FLOC2 &FSIZE &LLOC &QPC +
                          &MSET &DSVB &DSVQ &MSET2 &DSVB2 &DSVQ2 &RTN)
ENDP:        ENDPGM
