             PGM

             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOHZ ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ODRN ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BIN  ) TYPE(*CHAR) LEN(2)

             CHGVAR     VAR(&NONY ) VALUE('0579')
             CHGVAR     VAR(&NKOJ ) VALUE('0')
             CHGVAR     VAR(&NUKE ) VALUE('00  ')
             CHGVAR     VAR(&NOHZ ) VALUE('20240926')
             CHGVAR     VAR(&ODRN ) VALUE('20240926FA')

             CALL       PGM(UTLR72D) PARM(&NONY &NKOJ &NUKE &NOHZ +
                          &ODRN &BIN)

ENDP:        ENDPGM
