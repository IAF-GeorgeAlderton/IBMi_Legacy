             PGM

             CPYF       FROMFILE(HFILE1/FCEPP01) +
                          TOFILE(TFILE1/FCEPP01) MBROPT(*REPLACE)

             CPYF       FROMFILE(HFILE1/AAMPP11) +
                          TOFILE(TFILE1/AAMPP11) MBROPT(*REPLACE)

             CPYF       FROMFILE(HFILE1/FCEPP03) +
                          TOFILE(TFILE1/FCEPP03) MBROPT(*REPLACE)

             CPYF       FROMFILE(HFILE1/AAPPP01) +
                          TOFILE(TFILE1/AAPPP01) MBROPT(*REPLACE)

             CPYF       FROMFILE(HFILE1/AAFPP01) +
                          TOFILE(TFILE1/AAFPP01) MBROPT(*REPLACE)

             CPYF       FROMFILE(HFILE1/CADPP01) +
                          TOFILE(TFILE1/CADPP01) MBROPT(*REPLACE)

             CPYF       FROMFILE(HFILE1/AGDPP11) +
                          TOFILE(TFILE1/AGDPP11) MBROPT(*REPLACE)

             CPYF       FROMFILE(HFILE1/FGBPP01) +
                          TOFILE(TFILE1/FGBPP01) MBROPT(*REPLACE)

             CPYF       FROMFILE(HFILE1/FBCPP01) +
                          TOFILE(TFILE1/FBCPP01) MBROPT(*REPLACE)

             CPYF       FROMFILE(HFILE1/MBDPP11) +
                          TOFILE(TFILE1/MBDPP11) MBROPT(*REPLACE)

             CPYF       FROMFILE(HFILE1/NZTPP01) +
                          TOFILE(TFILE1/NZTPP01) MBROPT(*REPLACE)

             CPYF       FROMFILE(HFILE1/ABBPP01) +
                          TOFILE(TFILE1/ABBPP01) MBROPT(*REPLACE)

             CPYF       FROMFILE(HFILE1/AB#PP01) +
                          TOFILE(TFILE1/AB#PP01) MBROPT(*REPLACE) +
                          INCREL((*IF B1NOYY *EQ 2023) (*AND B1NOMM +
                          *GE 4))

             CPYF       FROMFILE(HFILE1/AB#PP10) +
                          TOFILE(TFILE1/AB#PP10) MBROPT(*REPLACE) +
                          INCREL((*IF BANOYY *EQ 2023) (*AND BANOMM +
                          *GE 4))

             CPYF       FROMFILE(HFILE1/NZUPP01) +
                          TOFILE(TFILE1/NZUPP01) MBROPT(*REPLACE) +
                          INCREL((*IF N2KOHZ *GE 20230401))

             CPYF       FROMFILE(HFILE1/STAPP10) +
                          TOFILE(TFILE1/STAPP10) MBROPT(*REPLACE) +
                          INCREL((*IF S1KOHZ *GE 20230401))

             ENDPGM
