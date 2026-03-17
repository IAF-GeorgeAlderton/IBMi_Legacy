             PGM

             DCL        VAR(&REC)    TYPE(*DEC)  LEN(10)

             CHGVAR     VAR(&REC) VALUE('0')
             RTVMBRD    FILE(HWFILE1/GDGWP46) NBRCURRCD(&REC)
             IF         COND(&REC > 0) THEN(DO)
                        CPYF   FROMFILE(HWFILE1/GDGWP46)  +
                               TOFILE(HWFILE1/GDGWP46A) +
                               MBROPT(*ADD)
             ENDDO

             CLRPFM     FILE(HWFILE1/GDGWP46)

             OVRDBF     FILE(AANPL03) TOFILE(HFILE1/AANPL03)
             OVRDBF     FILE(GDGPL45) TOFILE(HFILE1/GDGPL45)
             OVRDBF     FILE(GDGPL46) TOFILE(HFILE1/GDGPL46)
             OVRDBF     FILE(GDGWP46) TOFILE(HWFILE1/GDGWP46)
             OVRDBF     FILE(GDGWP47) TOFILE(HWFILE1/GDGWP47)

             OVRPRTF    FILE(QPRINT) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(LANPRT03) +
                          FORMTYPE(K6S1) SAVE(*YES)

             CALL       PGM(GDGR46)

             ENDPGM
