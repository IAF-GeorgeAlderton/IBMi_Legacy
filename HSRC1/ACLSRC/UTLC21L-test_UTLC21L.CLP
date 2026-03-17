             PGM
             /** UTLC21L ***************************************/
             /*  TEST UTLC21L                                  */
             /*  JW : J.WATANABE  2020.05.21                   */
             /**************************************************/

             DCL        VAR(&SHIN) TYPE(*CHAR) LEN(12)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&LC1 ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&LC2 ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&LC3 ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&LC4 ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&LC5 ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&LC6 ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&LC7 ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&LC8 ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&SHIN) VALUE('90119A0372  ')
             CHGVAR     VAR(&DATE) VALUE('20200521')

  CALL PGM(UTLR21L) PARM(&SHIN &DATE &LC1 &LC2 &LC3 &LC4 &LC5 &LC6 &LC7 &LC8 +
                                                    &RTN)

             ENDPGM
