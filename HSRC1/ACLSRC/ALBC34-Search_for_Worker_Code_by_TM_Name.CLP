             PGM

             DCL        VAR(&NM) TYPE(*CHAR) LEN(20)
             DCLF       FILE(ALBPW33) RCDFMT(DSP01)

 TOP:        SNDRCVF    RCDFMT(DSP01)

             IF         COND(&IN01 = '1') THEN(GOTO CMDLBL(END))

             CHGVAR     VAR(&NM) VALUE('''%' *TCAT &D1NAME *TCAT '%''')

             STRQMQRY   QMQRY(ALBPP30NM) ALWQRYDFN(*YES) +
                          SETVAR((NM &NM))

             GOTO       CMDLBL(TOP)

 END:        ENDPGM
