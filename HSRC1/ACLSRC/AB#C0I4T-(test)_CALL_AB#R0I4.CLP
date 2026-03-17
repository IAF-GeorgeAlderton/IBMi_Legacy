             PGM

             DCL        VAR(&UPD)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PLS)  TYPE(*DEC ) LEN(8 0)
             DCL        VAR(&NON)  TYPE(*DEC ) LEN(4 0)
             DCL        VAR(&NKO)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUK)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&BIN)  TYPE(*DEC ) LEN(2 0)
             DCL        VAR(&ODR)  TYPE(*CHAR) LEN(20)
             DCL        VAR(&MH1)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&MH2)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&MH3)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&MH4)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&QNT)  TYPE(*DEC ) LEN(9 0)
             DCL        VAR(&CNT)  TYPE(*DEC ) LEN(2 0)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&UPD) VALUE('Y')
             CHGVAR     VAR(&PLS) VALUE(20200618)
             CHGVAR     VAR(&NON) VALUE(2021)
             CHGVAR     VAR(&NKO) VALUE('0')
             CHGVAR     VAR(&NUK) VALUE('00  ')
             CHGVAR     VAR(&BIN) VALUE(01)
             CHGVAR     VAR(&ODR) VALUE('466014   ')
             CHGVAR     VAR(&MH1) VALUE('74650')
             CHGVAR     VAR(&MH2) VALUE('TBCA2')
             CHGVAR     VAR(&MH3) VALUE('10M1 ')
             CHGVAR     VAR(&MH4) VALUE(' ')
             CHGVAR     VAR(&QNT) VALUE(101)
             CHGVAR     VAR(&CNT) VALUE(3)
             CHGVAR     VAR(&RTN) VALUE('N')

             CALL       PGM(AB#R0I4) PARM(&UPD &PLS &NON &NKO &NUK +
                          &BIN &ODR &MH1 &MH2 &MH3 &MH4 &QNT &CNT &RTN)

             ENDPGM
