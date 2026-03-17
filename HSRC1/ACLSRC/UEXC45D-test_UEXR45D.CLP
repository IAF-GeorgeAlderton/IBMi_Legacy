             PGM
             /** UEXC45D **********************************************/
             /*  TEST UEXR45D                                         */
             /*-------------------------------------------------------*/

             DCL        VAR(&NONY   ) TYPE(*CHAR) LEN(4)  VALUE('3347')
             DCL        VAR(&NUKE   ) TYPE(*CHAR) LEN(4)  VALUE('P1  ')
             DCL        VAR(&NOHZ) TYPE(*CHAR) LEN(8) VALUE('20230413')
             DCL        VAR(&MAN#   ) TYPE(*CHAR) LEN(12) VALUE('2023041399SA')
             DCL        VAR(&SHPDT  ) TYPE(*CHAR) LEN(8)  VALUE('        ')

             CALL       PGM(UEXR45D) PARM(&NONY &NUKE &NOHZ &MAN# &SHPDT)

             ENDPGM
