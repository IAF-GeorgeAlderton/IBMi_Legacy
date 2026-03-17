             PGM
             /** UTLC33A ***************************************/
             /**************************************************/
             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MHIN ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&DATE ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SBAN ) TYPE(*CHAR) LEN(6)

             CHGVAR     VAR(&NONY ) VALUE('0578')
             CHGVAR     VAR(&NKOJ ) VALUE(' ')
             CHGVAR     VAR(&NUKE ) VALUE(' ')
             CHGVAR     VAR(&MHIN ) VALUE('90115A0040 ')
             CHGVAR     VAR(&DATE ) VALUE(' ')


   CALL  PGM(UTLR33C) PARM(&NONY &NKOJ &NUKE &MHIN &DATE &SBAN)

             ENDPGM
