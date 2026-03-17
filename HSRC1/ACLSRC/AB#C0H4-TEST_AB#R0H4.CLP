             PGM

             DCL        VAR(&ODRN) TYPE(*CHAR) LEN(12) +
                          VALUE('D0356D10')
             DCL        VAR(&NONY) TYPE(*CHAR) LEN(4) VALUE('3503')
             DCL        VAR(&NUKE) TYPE(*CHAR) LEN(4) VALUE('4W')
             DCL        VAR(&NOYY) TYPE(*DEC) LEN(4 0) VALUE(2020)
             DCL        VAR(&NOMM) TYPE(*DEC) LEN(2 0) VALUE(12)
             DCL        VAR(&NODD) TYPE(*DEC) LEN(2 0) VALUE(16)
             DCL        VAR(&MHN1) TYPE(*CHAR) LEN(5) VALUE('90119')
             DCL        VAR(&MHN2) TYPE(*CHAR) LEN(5) VALUE('A0461')
             DCL        VAR(&MHN3) TYPE(*CHAR) LEN(5) VALUE('00')
             DCL        VAR(&MHN4) TYPE(*CHAR) LEN(5)
             DCL        VAR(&TOTL) TYPE(*DEC) LEN(6 0)

             CALL       PGM(AB#R0H4) PARM(&ODRN &NONY &NUKE &NOYY +
                          &NOMM &NODD &MHN1 &MHN2 &MHN3 &MHN4 &TOTL)

             ENDPGM
