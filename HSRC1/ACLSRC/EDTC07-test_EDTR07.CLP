             PGM
             /** EDTC07  ***********************************/
             /** TEST EDTR07                               */
             /**********************************************/
             DCL        VAR(&YMD )  TYPE(*CHAR) LEN(8)
             DCL        VAR(&MDY1)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&MDY2)  TYPE(*CHAR) LEN(6)

             CHGVAR     VAR(&YMD)  VALUE('20240412')

             CALL       PGM(EDTR07) PARM(&YMD &MDY1 &MDY2)

             ENDPGM
