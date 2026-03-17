             /*********************************************************/
             /*  TEST - UEXR21E                                       */
             /*-------------------------------------------------------*/
             PGM        PARM(&SERL &ORD &SCN &UNS &RTN)

             DCL        VAR(&SERL  ) TYPE(*CHAR) LEN(9)
             DCL        VAR(&ORD   ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCN   ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&UNS   ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN   ) TYPE(*CHAR) LEN(1)

             CALL       PGM(UEXR21E) PARM(&SERL &ORD &SCN &UNS &RTN)

             ENDPGM
