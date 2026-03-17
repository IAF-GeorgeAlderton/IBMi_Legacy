             PGM
             /** UTLC24 ****************************************/
             /**************************************************/

             DCL        VAR(&DATE1) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DATE2) TYPE(*CHAR) LEN(8)
             DCL        VAR(&IAF )  TYPE(*CHAR) LEN(1)
             DCL        VAR(&DAYS)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&RTN )  TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&DATE1) VALUE('20180702')
             CHGVAR     VAR(&DATE2) VALUE('20180708')
             CHGVAR     VAR(&IAF)   VALUE('N')

             CALL       PGM(UTLR24) PARM(&DATE1 &DATE2 &IAF &DAYS &RTN)

             ENDPGM
