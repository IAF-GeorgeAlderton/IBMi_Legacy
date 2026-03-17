             PGM
             /** UTLC24D ***************************************/
             /**************************************************/

             DCL        VAR(&BDATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&FRIDY) TYPE(*CHAR) LEN(8)

             CHGVAR     VAR(&BDATE) VALUE('20240401')

             CALL       PGM(UTLR24D) PARM(&BDATE &FRIDY)

             ENDPGM
