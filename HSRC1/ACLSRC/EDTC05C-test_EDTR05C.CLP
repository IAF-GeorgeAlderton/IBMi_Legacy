             PGM
             /** EDTC05C ***********************************/
             /** TEST EDTR05C                              */
             /** JW   2024.06.12                           */
             /**********************************************/
             DCL        VAR(&IN)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&OUT)  TYPE(*CHAR) LEN(11)

             CHGVAR     VAR(&IN)   VALUE('   1000  ')

             CALL       PGM(EDTR05C) PARM(&IN &OUT)

             ENDPGM
