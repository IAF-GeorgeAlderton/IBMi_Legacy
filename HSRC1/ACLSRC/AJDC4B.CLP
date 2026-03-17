             PGM

             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&FILE) VALUE('AJSWP11')
             CALLSUBR   SUBR(CPYF)

             CHGVAR     VAR(&FILE) VALUE('AJSWP13')
             CALLSUBR   SUBR(CPYF)

             CHGVAR     VAR(&FILE) VALUE('AJSWP15')
             CALLSUBR   SUBR(CPYF)

             CHGVAR     VAR(&FILE) VALUE('AJSWP17')
             CALLSUBR   SUBR(CPYF)

             CHGVAR     VAR(&FILE) VALUE('AJSWP19')
             CALLSUBR   SUBR(CPYF)

             SUBR       SUBR(CPYF)
             CPYF       FROMFILE(&FILE) TOFILE(SAKABK/&FILE) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             CMPPFM     NEWFILE(&FILE) OLDFILE(SAKABK/&FILE)
             ENDSUBR

             ENDPGM
