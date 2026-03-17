             PGM
/** ABBC25A ************************************************/
/*  TEST ABBR25A                                           */
/***********************************************************/
             DCL        VAR(&SHIN) TYPE(*CHAR) LEN(12)
             DCL        VAR(&MHIN) TYPE(*CHAR) LEN(20)
             DCL        VAR(&TOKU) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NONY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SEBN) TYPE(*CHAR) LEN(4)

             CHGVAR     VAR(&SHIN) VALUE(' ')
             CHGVAR     VAR(&MHIN) VALUE(' ')
             CHGVAR     VAR(&TOKU) VALUE(' ')
             CHGVAR     VAR(&NONY) VALUE(' ')
             CHGVAR     VAR(&NKOJ) VALUE(' ')
             CHGVAR     VAR(&NUKE) VALUE(' ')
             CHGVAR     VAR(&SEBN) VALUE(' ')

             CALL       PGM(ABBR25A) PARM((&SHIN) (&MHIN) (&TOKU) (&NONY) +
                          (&NKOJ) (&NUKE) (&SEBN))

             ENDPGM
