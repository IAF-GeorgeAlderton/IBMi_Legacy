             PGM

             DCL        VAR(&KEY1) TYPE(*CHAR) LEN(8)
             DCL        VAR(&KEY2) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SEQ1) TYPE(*DEC ) LEN(11 0)
             DCL        VAR(&SEQ2) TYPE(*CHAR) LEN(11)

             CHGVAR     VAR(&KEY1) VALUE('BOCAR   ')
             CHGVAR     VAR(&KEY2) VALUE('INVOICE#')

             CALL       PGM(UEXR56 ) PARM(&KEY1 &KEY2 &SEQ1 &SEQ2)

             ENDPGM
