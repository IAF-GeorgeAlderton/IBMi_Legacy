             PGM
             /** UTLC61 ******************************************/
             /*  UTILITY- UTILITY- GET IAF PART# FROM USER PART  */
             /*  JW1: J-WATANABE             2018.06.12          */
             /****************************************************/
             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MHIN1) TYPE(*CHAR) LEN(20)
             DCL        VAR(&TOKU ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MHIN2) TYPE(*CHAR) LEN(20)
             DCL        VAR(&SHIN ) TYPE(*CHAR) LEN(12)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&NONY)  VALUE('0701')
             CHGVAR     VAR(&NKOJ)  VALUE('0')
             CHGVAR     VAR(&NUKE)  VALUE('T00')
             CHGVAR     VAR(&MHIN1) VALUE('900801021400  ')
             CHGVAR     VAR(&TOKU ) VALUE(' ')
             CHGVAR     VAR(&MHIN2) VALUE(' ')
             CHGVAR     VAR(&SHIN)  VALUE(' ')
             CHGVAR     VAR(&RTN)   VALUE(' ')

             CALL       PGM(UTLR61) PARM(&NONY &NKOJ &NUKE &MHIN1 &TOKU +
                          &MHIN2 &SHIN &RTN)

             ENDPGM
