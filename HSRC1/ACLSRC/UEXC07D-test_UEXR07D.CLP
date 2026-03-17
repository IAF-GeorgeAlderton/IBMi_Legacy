             /** UEXC07D **********************************************/
             /*  TEST - UEXR07D                                       */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&PL#   ) TYPE(*CHAR) LEN(09)
             DCL        VAR(&QTY   ) TYPE(*CHAR) LEN(08)
             DCL        VAR(&BOX   ) TYPE(*CHAR) LEN(04)
             DCL        VAR(&PLT   ) TYPE(*CHAR) LEN(03)
             DCL        VAR(&MAX   ) TYPE(*CHAR) LEN(03)
             DCL        VAR(&RTN   ) TYPE(*CHAR) LEN(01)

             CHGVAR     VAR(&PL# ) VALUE('210908527')
             CHGVAR     VAR(&QTY ) VALUE(' ')
             CHGVAR     VAR(&BOX ) VALUE(' ')
             CHGVAR     VAR(&PLT ) VALUE(' ')
             CHGVAR     VAR(&MAX ) VALUE(' ')
             CHGVAR     VAR(&RTN ) VALUE(' ')

             CALL       PGM(UEXR07D) PARM(&PL# &QTY &BOX &PLT &MAX &RTN)

             ENDPGM
