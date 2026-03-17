             PGM
             /** EDTC05B ***********************************/
             /** TEST EDTR05B                              */
             /** JW   2023.02.20                           */
             /**********************************************/
             DCL        VAR(&IN)     TYPE(*DEC) LEN(15 6)
             DCL        VAR(&TRUE)   TYPE(*CHAR) LEN(17)

             CHGVAR     VAR(&IN)   VALUE(80)

             CALL       PGM(EDTR05B) PARM(&IN &TRUE)

             ENDPGM
