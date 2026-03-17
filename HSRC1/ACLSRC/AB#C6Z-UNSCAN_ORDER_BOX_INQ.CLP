  PGM
/** AB#C6Z ************************************************/
/*  UNSCAN ORDER BOX INQ                                  */
/*  JW     2020.08.28                                     */
/**********************************************************/
             DCL        VAR(&NOHZF) TYPE(*DEC ) LEN(8 0)
             DCL        VAR(&NOHZT) TYPE(*DEC ) LEN(8 0)
             DCL        VAR(&TOKU)  TYPE(*DEC ) LEN(4 0)
             DCL        VAR(&NONY)  TYPE(*DEC ) LEN(4 0)
             DCL        VAR(&NOBN)  TYPE(*DEC ) LEN(2 0)
             DCL        VAR(&SHN1)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&SHN2)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&SHN3)  TYPE(*CHAR) LEN(2)

             CHGVAR     VAR(&NOHZF) VALUE(0)
             CHGVAR     VAR(&NOHZT) VALUE(0)
             CHGVAR     VAR(&TOKU ) VALUE(0)
             CHGVAR     VAR(&NONY ) VALUE(0)
             CHGVAR     VAR(&NOBN ) VALUE(0)
             CHGVAR     VAR(&SHN1 ) VALUE(' ')
             CHGVAR     VAR(&SHN2 ) VALUE(' ')
             CHGVAR     VAR(&SHN3 ) VALUE(' ')

             CALL       PGM(AB#R6Z) PARM(&NOHZF &NOHZT &TOKU &NONY +
                          &NOBN &SHN1 &SHN2 &SHN3)


             ENDPGM
