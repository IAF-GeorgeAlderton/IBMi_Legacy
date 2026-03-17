             PGM
             DCL        VAR(&HIN1) TYPE(*CHAR) LEN(5) VALUE('90119')
             DCL        VAR(&HIN2) TYPE(*CHAR) LEN(5) VALUE('A0397')
             DCL        VAR(&HIN3) TYPE(*CHAR) LEN(2) VALUE('  ')
             DCL        VAR(&HAYY) TYPE(*CHAR) LEN(4) VALUE('2015')
             DCL        VAR(&HAMM) TYPE(*CHAR) LEN(2) VALUE('10')
             DCL        VAR(&HADD) TYPE(*CHAR) LEN(2) VALUE('16')
             DCL        VAR(&HABB) TYPE(*CHAR) LEN(2) VALUE('03')

             DCL        VAR(&HKSU) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SISU) TYPE(*CHAR) LEN(5)
             DCL        VAR(&NYSU) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SYSU) TYPE(*CHAR) LEN(5)
             DCL        VAR(&KISU) TYPE(*CHAR) LEN(5)
             DCL        VAR(&INV ) TYPE(*CHAR) LEN(5)

             CALL       PGM(NYUR21) PARM(&HIN1 &HIN2 &HIN3 &HAYY +
                          &HAMM &HADD &HABB &HKSU &SISU &NYSU &SYSU +
                          &KISU &INV)

 SEND:       ENDPGM
