             PGM        PARM(&PL#)
             /** UEXC49A **********************************************/
             /*  TEST UEXR49A                                         */
             /*-------------------------------------------------------*/
             DCL        VAR(&PL#) TYPE(*CHAR) LEN(9)
             DCL        VAR(&STT) TYPE(*CHAR) LEN(1) VALUE(' ')

             CALL       PGM(UEXR49A) PARM(&PL#  &STT)

             ENDPGM
