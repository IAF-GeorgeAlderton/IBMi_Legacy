             PGM
             DCL        VAR(&HIN1) TYPE(*CHAR) LEN(5) VALUE('90119')
             DCL        VAR(&HIN2) TYPE(*CHAR) LEN(5) VALUE('A0397')
             DCL        VAR(&HIN3) TYPE(*CHAR) LEN(2) VALUE('  ')
             DCL        VAR(&HAYY) TYPE(*CHAR) LEN(4) VALUE('2015')
             DCL        VAR(&HAMM) TYPE(*CHAR) LEN(2) VALUE('10')
             DCL        VAR(&HADD) TYPE(*CHAR) LEN(2) VALUE('16')
             DCL        VAR(&HABB) TYPE(*CHAR) LEN(2) VALUE('04')

             CALL       PGM(NYUR20) PARM(&HIN1 &HIN2 &HIN3 &HAYY +
                          &HAMM &HADD &HABB)

 SEND:       ENDPGM
