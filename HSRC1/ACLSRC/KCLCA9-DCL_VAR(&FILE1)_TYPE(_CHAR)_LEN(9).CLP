             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WS) USER(&US)
             CHGVAR     VAR(&WT) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(&FILE1) VALUE('AUBWP51' *CAT &WT)

             OVRDBF     FILE(AUBWP51) TOFILE(&FILE1)

             CALL       PGM(AUBR59)

             CLRPFM     FILE(&FILE1)
             DLTOVR     FILE(*ALL)
 END:        ENDPGM
