             PGM
             /** AB#C5W **********************************/
             /*  ..RETRY                                 */
             /*                                          */
             /********************************** AB#C5W **/
             DCL        VAR(&FLAG)    TYPE(*CHAR) LEN(1)


             CALL       PGM(AB#R5W) PARM(&FLAG)

             IF         COND(&FLAG *EQ ' ') THEN(GOTO CMDLBL(@END))

             CALL       PGM(AB#C5X)

 @END:        ENDPGM
