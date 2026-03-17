             PGM
             /** EDTC04B ***********************************/
             /** TEST EDTR04B                              */
             /** JW   2023.02.20                           */
             /**********************************************/
             DCL        VAR(&IN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&OUT)  TYPE(*CHAR) LEN(4)

             CHGVAR     VAR(&IN)   VALUE('291 ')

             CALL       PGM(EDTR04B) PARM(&IN &OUT)

             ENDPGM
