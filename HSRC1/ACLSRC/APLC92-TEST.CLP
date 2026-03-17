             PGM
             /**** APLC92 *****************************************/
             /* APLR92 TESTER                                     */
             /* T.SAKASHITA 2021.01.25                            */
             /*****************************************************/
             DCL        VAR(&PMSG) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PWSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&PMSG) VALUE('TEST')
             CHGVAR     VAR(&PKINP) VALUE('GC   ')
             CHGVAR     VAR(&PWSNO) VALUE(' ')
             CHGVAR     VAR(&PKOUT) VALUE(' ')

             CALL       PGM(APLR92)  PARM(&PMSG -
                                          &PKINP -
                                          &PWSNO -
                                          &PKOUT)

             CALL       PGM(APLR90)  PARM(&PMSG -
                                          &PKINP -
                                          &PWSNO -
                                          &PKOUT)

             ENDPGM
