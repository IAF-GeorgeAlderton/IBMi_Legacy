             PGM

             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NKOJ ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NUKE ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NOHZ ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&BIN1 ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&BIN2 ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&NONY ) VALUE('0479')
             CHGVAR     VAR(&NKOJ ) VALUE('0')
             CHGVAR     VAR(&NUKE ) VALUE('AT  ')
             CHGVAR     VAR(&NOHZ ) VALUE('20240926')

             CALL       PGM(UTLR72B) PARM(&NONY &NKOJ &NUKE &NOHZ +
                          &BIN1 &BIN2 &RTN)

ENDP:        ENDPGM
