             PGM
             /** UEXC41D **********************************************/
             /*  TEST UEXR41D                                         */
             /*-------------------------------------------------------*/

             DCL        VAR(&DATE ) TYPE(*CHAR) LEN(8)  VALUE('20260207')
             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)  VALUE('5150')
             DCL        VAR(&MHIN ) TYPE(*CHAR) LEN(20) VALUE('W712511S439 ')
             DCL        VAR(&PLNT ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&YTDQ ) TYPE(*CHAR) LEN(9)

             CALL       PGM(UEXR41D) PARM(&DATE &NONY &MHIN &PLNT &YTDQ)

             ENDPGM
