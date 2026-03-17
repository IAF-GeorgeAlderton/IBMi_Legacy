             PGM

             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOHZ ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MHIN ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&ODRN ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BIN1 ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&BIN2 ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&STT  ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&NONY ) VALUE('0567')
             CHGVAR     VAR(&NKOJ ) VALUE('0')
             CHGVAR     VAR(&NUKE ) VALUE('00')
             CHGVAR     VAR(&NOHZ ) VALUE('20240311')
             CHGVAR     VAR(&MHIN ) VALUE('9261660610 ')
             CHGVAR     VAR(&ODRN ) VALUE('40311IAF01')
             CHGVAR     VAR(&BIN1 ) VALUE(' ')
             CHGVAR     VAR(&BIN2 ) VALUE(' ')
             CHGVAR     VAR(&STT  ) VALUE(' ')

             CALL       PGM(UTLR72C) PARM(&NONY &NKOJ &NUKE &NOHZ +
                          &MHIN &ODRN &BIN1 &BIN2 &STT)

ENDP:        ENDPGM
