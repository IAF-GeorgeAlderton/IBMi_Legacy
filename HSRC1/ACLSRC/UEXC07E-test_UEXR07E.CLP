             /** UEXC07E **********************************************/
             /*  TEST - UEXR07E                                       */
             /*-------------------------------------------------------*/
             PGM

             DCL        VAR(&NONY  ) TYPE(*CHAR) LEN(04)
             DCL        VAR(&NKOJ  ) TYPE(*CHAR) LEN(01)
             DCL        VAR(&NUKE  ) TYPE(*CHAR) LEN(04)
             DCL        VAR(&NOHZ  ) TYPE(*CHAR) LEN(08)
             DCL        VAR(&NOBN  ) TYPE(*CHAR) LEN(02)
             DCL        VAR(&QTY   ) TYPE(*CHAR) LEN(08)
             DCL        VAR(&BOX   ) TYPE(*CHAR) LEN(04)
             DCL        VAR(&PLT   ) TYPE(*CHAR) LEN(03)
             DCL        VAR(&MAX   ) TYPE(*CHAR) LEN(03)
             DCL        VAR(&RTN   ) TYPE(*CHAR) LEN(01)

             CHGVAR     VAR(&NONY) VALUE('0203')
             CHGVAR     VAR(&NKOJ) VALUE('0')
             CHGVAR     VAR(&NUKE) VALUE('00')
             CHGVAR     VAR(&NOHZ) VALUE('20211005')
             CHGVAR     VAR(&NOBN) VALUE('01')
             CHGVAR     VAR(&QTY ) VALUE(' ')
             CHGVAR     VAR(&BOX ) VALUE(' ')
             CHGVAR     VAR(&PLT ) VALUE(' ')
             CHGVAR     VAR(&MAX ) VALUE(' ')
             CHGVAR     VAR(&RTN ) VALUE(' ')

             CALL       PGM(UEXR07E) PARM(&NONY &NKOJ &NUKE &NOHZ +
                          &NOBN &QTY &BOX &PLT &MAX &RTN)

             ENDPGM
