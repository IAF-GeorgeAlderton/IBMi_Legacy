             PGM
             /** FIXC03 ****************************************/
             /*  TEST FIXR03                                   */
             /*  JW   2024.10.29                               */
             /**************************************************/
             DCL        VAR(&TOKU) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NONY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOHZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ODRN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BINF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&BINT) TYPE(*CHAR) LEN(2)

             CHGVAR     VAR(&TOKU) VALUE('3411')
             CHGVAR     VAR(&NONY) VALUE('0323')
             CHGVAR     VAR(&NKOJ) VALUE('C')
             CHGVAR     VAR(&NUKE) VALUE('G   ')
             CHGVAR     VAR(&NOHZ) VALUE('20241031')
             CHGVAR     VAR(&ODRN) VALUE('    ')
             CHGVAR     VAR(&BINF) VALUE('09')
             CHGVAR     VAR(&BINT) VALUE('01')

             CALL      FIXR03 (&TOKU &NONY &NKOJ &NUKE &NOHZ &ODRN &BINF &BINT)

             ENDPGM
