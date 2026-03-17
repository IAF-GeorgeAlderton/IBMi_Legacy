             PGM

             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PMHIN) TYPE(*CHAR) LEN(20)
             DCL        VAR(&MSG1 ) TYPE(*CHAR) LEN(90)

             RTVJOBA    JOB(&WSID)

             CHGVAR     VAR(&MSG1) VALUE('PLEASE REGISTER UNIT PRICE +
                          BEFORE ISSUING  CANADA CUSTOM SHEET. +
                          (AB#C3S)')
             CHGVAR     VAR(&PMHIN) VALUE('90010-12345')
             CHGVAR     VAR(&PSIRE) VALUE('3503')

             SNDPGMMSG  MSG(&MSG1 *BCAT &PMHIN *BCAT &PSIRE) +
                          TOMSGQ(&WSID)

             ENDPGM
