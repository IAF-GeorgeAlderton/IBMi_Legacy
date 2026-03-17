             PGM
             /** UTLC35 ****************************************/
             /**************************************************/
             DCL        VAR(&TOKU ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MHIN ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&HTYP ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&DATE ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SYOS ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&TOKU ) VALUE('0295')
             CHGVAR     VAR(&NONY ) VALUE('2021')
             CHGVAR     VAR(&MHIN ) VALUE('90105TBAA000')
             CHGVAR     VAR(&HTYP ) VALUE('USR')
             CHGVAR     VAR(&DATE ) VALUE('20220121')

   CALL  PGM(UTLR35) PARM(&TOKU &NONY &MHIN &HTYP &DATE &SYOS &RTN)

             ENDPGM
