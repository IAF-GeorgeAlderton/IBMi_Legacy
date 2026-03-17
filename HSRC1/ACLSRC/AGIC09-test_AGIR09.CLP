             PGM
             /*** AGIC09 ***********************************/
             /* JW                                         */
             /**********************************************/
             DCL        VAR(&CBSHN1 ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&CBSHN2 ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&CBSHN3 ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&P1DATE ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&P1BIN  ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&P9K001 ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P9K002 ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P9K003 ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P9K004 ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P9K005 ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P9K006 ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P9K007 ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P9K008 ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P9K009 ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P9K010 ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P9SORT ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&P9MS01 ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P9MS02 ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P9MS03 ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P9MS04 ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P9MS05 ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P9MS06 ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P9MS07 ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P9MS08 ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P9MS09 ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P9MS10 ) TYPE(*CHAR) LEN(3)

             CHGVAR     VAR(&CBSHN1 ) VALUE('U0605')
             CHGVAR     VAR(&CBSHN2 ) VALUE('B5040')
             CHGVAR     VAR(&CBSHN3 ) VALUE('     ')
             CHGVAR     VAR(&P1DATE ) VALUE('20200301')
             CHGVAR     VAR(&P1BIN  ) VALUE('01')

             CALL       PGM(AGIR09) PARM(&CBSHN1 &CBSHN2 &CBSHN3 +
                                    &P1DATE &P1BIN  +
                                    &P9K001 &P9K002 &P9K003 &P9K004 &P9K005 +
                                    &P9K006 &P9K007 &P9K008 &P9K009 &P9K010 +
                                    &P9SORT +
                                    &P9MS01 &P9MS02 &P9MS03 &P9MS04 &P9MS05 +
                                    &P9MS06 &P9MS07 &P9MS08 &P9MS09 &P9MS10 )

 END:
             ENDPGM
