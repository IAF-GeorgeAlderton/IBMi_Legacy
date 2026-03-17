             PGM

             DCL        VAR(&PARM1)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM2)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM3)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM4)  TYPE(*CHAR) LEN(52)
             DCL        VAR(&PARM5)  TYPE(*CHAR) LEN(2)

             CHGVAR     VAR(&PARM1) VALUE('HSRC1')
             CHGVAR     VAR(&PARM2) VALUE('ARPGSRC')
             CHGVAR     VAR(&PARM3) VALUE('IAF')
             CHGVAR     VAR(&PARM4) VALUE('C:/AS400/DATA/IAFTEST.TXT')
             CHGVAR     VAR(&PARM5) VALUE(' 1')

             CALL       PGM(APLC98) PARM(&PARM1 &PARM2 &PARM3 &PARM4 +
                          &PARM5)

             ENDPGM
