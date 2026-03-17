             PGM

             DCL        VAR(&TOKU ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MHIN ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&SHIN ) TYPE(*CHAR) LEN(12)
             DCL        VAR(&OK   ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&TOKU ) VALUE('3411')
             CHGVAR     VAR(&NONY ) VALUE('3804')
             CHGVAR     VAR(&NKOJ ) VALUE('0')
             CHGVAR     VAR(&NUKE ) VALUE('M8  ')
             CHGVAR     VAR(&MHIN ) VALUE('90105A039300 ')

      CALL PGM(BBHR50) PARM(&TOKU &NONY &NKOJ &NUKE &MHIN &SHIN &OK)

             ENDPGM
