             PGM        PARM(&N &F &L)

             DCL        VAR(&N) TYPE(*CHAR) LEN(10)
             DCL        VAR(&F) TYPE(*CHAR) LEN(10)
             DCL        VAR(&L) TYPE(*CHAR) LEN(10)

             CPYSRCF    FROMFILE(&L/&F) TOFILE(SAVEPGM/QCLSRC) +
                          FROMMBR(&N) TOMBRID(*FROMMBR) +
                          MBROPT(*REPLACE) SRCCHGDATE(*FROMMBR)


             ENDPGM
