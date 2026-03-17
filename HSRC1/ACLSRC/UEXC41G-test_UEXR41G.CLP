             PGM
             /** UEXC41G **********************************************/
             /*  TEST UEXR41G                                         */
             /*-------------------------------------------------------*/

             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)  VALUE('5099')
             DCL        VAR(&DOCK ) TYPE(*CHAR) LEN(4)  VALUE('01')
             DCL        VAR(&STHZ ) TYPE(*CHAR) LEN(8)  VALUE('        ')
             DCL        VAR(&LSHZ ) TYPE(*CHAR) LEN(8)

             CALL       PGM(UEXR41G) PARM(&NONY &DOCK &STHZ &LSHZ )

             ENDPGM
