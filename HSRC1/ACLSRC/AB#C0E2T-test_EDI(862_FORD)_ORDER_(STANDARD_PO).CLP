             PGM
             /** AB#C0E2 *********************************/
             /*  EDI(862 FORD) ORDER (STANDARD PO)       */
             /*  JW      2021.12.01                      */
             /********************************************/

             CLRPFM     FILE(TFILE1/AB#PPF1)

             OVRDBF     FILE(AB#EP50) TOFILE(TFILE1/AB#EP50)
             OVRDBF     FILE(AB#PLF1) TOFILE(TFILE1/AB#PLF1)

             CALL       PGM(HOBJ1/AB#R0E2A)

             ENDPGM
