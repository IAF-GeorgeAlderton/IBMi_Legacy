             PGM        PARM(&PRTN &DAT1 &TIM1 &DAT2 &TIM2 &BCH# &INT#)

             DCL        VAR(&PRTN) TYPE(*CHAR) LEN(30)
             DCL        VAR(&DAT1) TYPE(*CHAR) LEN(08)
             DCL        VAR(&TIM1) TYPE(*CHAR) LEN(04)
             DCL        VAR(&DAT2) TYPE(*CHAR) LEN(08)
             DCL        VAR(&TIM2) TYPE(*CHAR) LEN(06)
             DCL        VAR(&BCH#) TYPE(*CHAR) LEN(07)
             DCL        VAR(&INT#) TYPE(*CHAR) LEN(14)

             OVRDBF     FILE(AUDREC98) TOFILE(G3X6DTA/AUDREC98)

    CALL PGM(UEXR58TX) PARM(&PRTN &DAT1 &TIM1 &DAT2 &TIM2 &BCH# &INT#)

             DLTOVR     FILE(*ALL)

             ENDPGM
