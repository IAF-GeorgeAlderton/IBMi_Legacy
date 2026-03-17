             PGM

             CPYF       FROMFILE(MEKI_RST18/RESULTFILE) +
                          TOFILE(AJUWP20) MBROPT(*REPLACE) +
                          INCCHAR(*RCD 1 *EQ 'D') FMTOPT(*NOCHK)

             EDTDTA     FILE(AJUWP20)

             CPYF       FROMFILE(AJUWP20) TOFILE(AJUPP20) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)

             EDTDTA     FILE(AJUPP20)

             ENDPGM
