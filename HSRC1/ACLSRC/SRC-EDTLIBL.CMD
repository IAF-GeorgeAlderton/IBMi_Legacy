             CMD
             PARM       KWD(PGM) TYPE(QUAL1) MIN(1) PGM(*YES) +
                          PROMPT('プログラム')
 QUAL1:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*CURLIB) +
                            SPCVAL((*CURLIB)) PROMPT('ライブラリー')
