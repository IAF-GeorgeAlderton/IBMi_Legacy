             PGM
             /** ABAC1AT *************************************/
             /*  TEST ABAR1A2                                */
             /*  JW    2023.1.28                             */
             /************************************************/

             DCL        VAR(&REC)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&ERR1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ERR2) TYPE(*CHAR) LEN(1)

             CLRPFM     FILE(TWFILE1/ABAWP10)
             CLRPFM     FILE(TFILE1/ABBPP01)
             CLRPFM     FILE(TFILE1/ABBPP50)
             CLRPFM     FILE(TFILE1/ABAEP25)
             CLRPFM     FILE(TFILE1/ABAPP10)
             CLRPFM     FILE(TWFILE1/ABAWP2H)
             CLRPFM     FILE(TFILE1/ABBPP01S)

             OVRDBF     FILE(ABAEP20) TOFILE(TFILE1/ABAEP20)
             OVRDBF     FILE(ABAWP10) TOFILE(TWFILE1/ABAWP10)
             OVRDBF     FILE(ABBPL01) TOFILE(TFILE1/ABBPL01)
             OVRDBF     FILE(ABAEP25) TOFILE(TFILE1/ABAEP25)

             CALL       PGM(ABAR1A2) PARM(&REC &ERR1 &ERR2)

             ENDPGM
