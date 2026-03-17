             PGM
             /** UTLC06A ***************************************/
             /*  CALL REFORMATION PROGRAM                      */
             /*  JW1: J-WATANABE             2017.04.06        */
             /**************************************************/

             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PART ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&TYP  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CO   ) TYPE(*CHAR) LEN(3)

             CHGVAR     VAR(&NONY)  VALUE('0701')
             CHGVAR     VAR(&PART)  VALUE('9017906362    ')
             CHGVAR     VAR(&TYP )  VALUE('I')

             CALL       PGM(UTLR06A) PARM(&PART &NONY &TYP  &CO)

             ENDPGM
