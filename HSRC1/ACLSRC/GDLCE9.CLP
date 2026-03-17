             PGM        PARM(&FLG)

             DCL        VAR(&FLG) TYPE(*CHAR) LEN(1)

             CPYF       FROMFILE(GDLPP01) TOFILE(TFILE1/GDLPP01) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             CPYF       FROMFILE(BTBPP41) TOFILE(TFILE1/BTBPP41) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             CPYF       FROMFILE(BTBPP05) TOFILE(TFILE1/BTBPP05) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             ENDPGM
