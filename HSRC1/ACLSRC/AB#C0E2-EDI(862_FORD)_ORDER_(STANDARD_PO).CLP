             PGM
             /** AB#C0E2 *********************************/
             /*  EDI(862 FORD) ORDER (STANDARD PO)       */
             /*  JW      2021.12.01                      */
             /* ----------------------------------       */
             /*  JW      2024.11.11 ADD ABBC54T          */
             /********************************************/

        /**  CLRPFM     FILE(HFILE1/AB#PPF1)                **/

             OVRDBF     FILE(AB#EP50) TOFILE(HFILE1/AB#EP50)
             OVRDBF     FILE(AB#PLF1) TOFILE(HFILE1/AB#PLF1)

             CALL       PGM(HOBJ1/AB#R0E2A)

/* SET UP ABBPP53 (FORD EDI862) */
             CALL       PGM(HOBJ1/ABBC54T )

             ENDPGM
