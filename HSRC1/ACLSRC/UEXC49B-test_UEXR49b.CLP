             PGM        PARM(&PL#)
             /** UEXC49B **********************************************/
             /*  TEST UEXR49B                                         */
             /*-------------------------------------------------------*/
             DCL        VAR(&PL#) TYPE(*CHAR) LEN(9)
             DCL        VAR(&PRC) TYPE(*CHAR) LEN(1) VALUE('A')
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(10) VALUE('XXX')

             CALL       PGM(UEXR49B) PARM(&PL# &PRC &PGM)

             ENDPGM
