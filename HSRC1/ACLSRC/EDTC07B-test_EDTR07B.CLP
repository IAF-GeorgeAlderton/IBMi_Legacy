             PGM
             /** EDTC07B ***********************************/
             /** TEST EDTR07B                              */
             /**********************************************/
             DCL        VAR(&MDY )  TYPE(*CHAR) LEN(8)
             DCL        VAR(&YMD1)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&YMD2)  TYPE(*CHAR) LEN(6)

             CHGVAR     VAR(&MDY)  VALUE('04122024')

             CALL       PGM(EDTR07B) PARM(&MDY &YMD1 &YMD2)

             ENDPGM
