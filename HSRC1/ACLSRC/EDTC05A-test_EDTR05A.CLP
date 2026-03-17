             PGM
             /** EDTC05A ***********************************/
             /** TEST EDTR05A                              */
             /** JW   2023.02.20                           */
             /**********************************************/
             DCL        VAR(&IN)     TYPE(*DEC) LEN(15 6)
             DCL        VAR(&TRUE)   TYPE(*CHAR) LEN(17)
             DCL        VAR(&RTN )   TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&IN)   VALUE(521.7)

             CALL       PGM(EDTR05A) PARM(&IN &TRUE &RTN)

             ENDPGM
