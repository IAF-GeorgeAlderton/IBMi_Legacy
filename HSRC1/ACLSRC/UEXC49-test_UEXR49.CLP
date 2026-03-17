             PGM
             /** UEXC49  **********************************************/
             /*  TEST UEXR49                                          */
             /*-------------------------------------------------------*/

             DCL        VAR(&PL#    ) TYPE(*CHAR) LEN(9)  VALUE('250107864')
             DCL        VAR(&STT    ) TYPE(*CHAR) LEN(1)  VALUE(' ')

             CALL       PGM(UEXR49 ) PARM(&PL#  &STT)

             ENDPGM
