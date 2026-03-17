             PGM
             /** UTLC61A *****************************************/
             /*  UTILITY- UTILITY- GET IAF PART# FROM USER PART  */
             /*  JW1: J-WATANABE             2024.05.01          */
             /****************************************************/
             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MHIN ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&SHIN ) TYPE(*CHAR) LEN(12)

             CHGVAR     VAR(&NONY)  VALUE('3318')
             CHGVAR     VAR(&MHIN)  VALUE('72702X7V3200')
             CHGVAR     VAR(&SHIN)  VALUE(' ')

             CALL       PGM(UTLR61A) PARM(&NONY &MHIN  &SHIN)

             ENDPGM
