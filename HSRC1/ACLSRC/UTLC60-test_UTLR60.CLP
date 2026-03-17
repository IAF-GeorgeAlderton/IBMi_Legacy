             PGM
             /** UTLC60 ****************************************/
             /*  UTILITY- CONVERT NUMERIC (CHAR TO NUMERIC)    */
             /*  JW1: J-WATANABE             2018.06.11        */
             /**************************************************/

             DCL        VAR(&IN )  TYPE(*CHAR) LEN(17)
             DCL        VAR(&TRUE) TYPE(*DEC)  LEN(15 6)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&IN) VALUE('123              ')
             CHGVAR     VAR(&TRUE) VALUE(0)
             CHGVAR     VAR(&RTN)  VALUE(' ')

             CALL       PGM(UTLR60) PARM(&IN &TRUE &RTN)

             ENDPGM
