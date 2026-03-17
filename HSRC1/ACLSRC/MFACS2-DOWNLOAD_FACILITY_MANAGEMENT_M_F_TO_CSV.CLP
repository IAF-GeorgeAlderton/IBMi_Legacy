             PGM        PARM(&KBN1 &KGUN &COS1 &COS2 &COS3 &SYS1 &SYS2)
             /* MFACS2 ********************************************/
             /* DOWNLOAD FACILITY MANAGEMENT M/F TO CSV           */
             /* J.W      2025.12.02                               */
             /*****************************************************/
             DCL        VAR(&KBN1)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&KGUN)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&COS1)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&COS2)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&COS3)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&SYS1)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&SYS2)   TYPE(*CHAR) LEN(4)

             DCL        VAR(&FNAM)   TYPE(*CHAR) LEN(30)

             CLRPFM     FILE(HWFILE1/MFAWP21)

             CALL PGM(MFARS2) PARM(&KBN1 &KGUN &COS1 &COS2 &COS3 &SYS1 &SYS2)

             CHGVAR     VAR(&FNAM) VALUE('FACILITY MANAGEMENT')
             CALL       PGM(APLC94) PARM('2' 'MFAWP21' 'HWFILE1' &FNAM +
                          'Y' ' ' 'Y')
             ENDPGM
