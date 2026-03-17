             PGM
             /** UTLC33A ***************************************/
             /**************************************************/
             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MHIN ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&DATE ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SBAN ) TYPE(*CHAR) LEN(6)

             CHGVAR     VAR(&NONY ) VALUE('0492')
             CHGVAR     VAR(&NKOJ ) VALUE(' ')
             CHGVAR     VAR(&NUKE ) VALUE(' ')
             CHGVAR     VAR(&MHIN ) VALUE('90105A0068')
             CHGVAR     VAR(&DATE ) VALUE('99999999')


   CALL  PGM(UTLR33A) PARM(&NONY &NKOJ &NUKE &MHIN &DATE &SBAN)

             ENDPGM
