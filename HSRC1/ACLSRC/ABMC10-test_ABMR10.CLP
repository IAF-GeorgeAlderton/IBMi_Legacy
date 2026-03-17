             PGM
             /** ABMC10 ************************/
             /*  TEST ABMR10                   */
             /*  JW   2025.11.04               */
             /**********************************/
             DCL        VAR(&DTYM) TYPE(*DEC)  LEN(6 0) VALUE(0)
             DCL        VAR(&CMD)  TYPE(*CHAR) LEN(2)   VALUE(' ')
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(10)  VALUE(' ')

             CALL       PGM(ABMR10)  PARM(&DTYM &CMD &PRT)

             ENDPGM
