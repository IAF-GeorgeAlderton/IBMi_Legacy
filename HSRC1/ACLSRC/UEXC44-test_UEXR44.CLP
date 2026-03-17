             PGM
             /** UEXC44  **********************************************/
             /*  TEST UEXR44                                          */
             /*-------------------------------------------------------*/

             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)  VALUE('0681')
             DCL        VAR(&NKOJ ) TYPE(*CHAR) LEN(1)  VALUE('0')
             DCL        VAR(&NUKE ) TYPE(*CHAR) LEN(4)  VALUE('00  ')
             DCL        VAR(&MHIN ) TYPE(*CHAR) LEN(20) VALUE('9008011701 ')
             DCL        VAR(&TYP  ) TYPE(*CHAR) LEN(1)  VALUE(' ')

             CALL       PGM(UEXR44 ) PARM(&NONY &NKOJ &NUKE &MHIN &TYP )

             ENDPGM
