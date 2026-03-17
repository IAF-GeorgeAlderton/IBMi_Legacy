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

             CHGVAR     VAR(&TOKU ) VALUE('3411')
             CHGVAR     VAR(&NONY ) VALUE('3804')
             CHGVAR     VAR(&MHIN ) VALUE('90105A039300')
             CHGVAR     VAR(&HTYP ) VALUE('USR')
             CHGVAR     VAR(&DATE ) VALUE('20231023')

   CALL  PGM(UTLR35C) PARM(&TOKU &NONY &MHIN &HTYP &DATE &SYOS &RTN)

             ENDPGM
