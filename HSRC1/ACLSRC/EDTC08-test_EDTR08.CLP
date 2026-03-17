             PGM
             /** EDTC08  ***********************************/
             /** TEST EDTR08                               */
             /**********************************************/
             DCL        VAR(&NONY)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&YM  )  TYPE(*CHAR) LEN(6)
             DCL        VAR(&MHIN)  TYPE(*CHAR) LEN(20)

             CHGVAR     VAR(&NONY) VALUE('5253')
             CHGVAR     VAR(&YM)   VALUE('202407')
             CHGVAR     VAR(&MHIN) VALUE('209139A')

             CALL       PGM(EDTR08 ) PARM(&NONY &YM   &MHIN)

             ENDPGM
