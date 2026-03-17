             PGM
             /** UEXC47  **********************************************/
             /*  TEST UEXR47                                          */
             /*-------------------------------------------------------*/

             DCL        VAR(&NONY   ) TYPE(*CHAR) LEN(4)  VALUE('5446')
             DCL        VAR(&NOHZ   ) TYPE(*CHAR) LEN(8)  VALUE('20240408')
             DCL        VAR(&MHIN   ) TYPE(*CHAR) LEN(20) VALUE('82417   ')
             DCL        VAR(&BASE   ) TYPE(*CHAR) LEN(8)  VALUE(' ')
             DCL        VAR(&CQTY   ) TYPE(*CHAR) LEN(8)  VALUE(' ')

             CALL       PGM(UEXR47 ) PARM(&NONY &NOHZ &MHIN &BASE &CQTY)

             ENDPGM
